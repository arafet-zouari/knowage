/*
 * Knowage, Open Source Business Intelligence suite
 * Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.
 *
 * Knowage is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Knowage is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package it.eng.spagobi.commons.utilities;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.SecureRandom;
import java.security.Signature;
import java.security.SignatureException;
import java.security.spec.EncodedKeySpec;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

import it.eng.spago.base.SourceBean;
import it.eng.spago.configuration.ConfigSingleton;

/**
 * Contains some SpagoBI's security utilities.
 */
public class SecurityUtilities {

	/**
	 * Get the SpagoBI Provate Key for a DSA alghoritm.
	 *
	 * @return PrivateKey DSA alghoritm for SpagoBI
	 */
	public PrivateKey getPrivateKeyDSA() {
		PrivateKey privKey = null;
		// get config singleton
		ConfigSingleton conf = ConfigSingleton.getInstance();
	    // get the name of the spagobi private key
	    SourceBean nameSbiPrivKeySB = (SourceBean)conf.getAttribute("SPAGOBI.SERVICE_SECURITY.SPAGOBI_PRIVATE_KEY_DSA");
	    String logicalName = nameSbiPrivKeySB.getCharacters();
		// get the input stream of the key file
	    InputStream privKeyIs = this.getClass().getClassLoader().getResourceAsStream(logicalName);
	    try {
	       	ByteArrayOutputStream baos = new ByteArrayOutputStream();
	       	byte[] buffer = new byte[1024];
	       	int len;
	       	while ((len = privKeyIs.read(buffer)) >= 0)
	       		baos.write(buffer, 0, len);
	       	privKeyIs.close();
	       	baos.close();
	       	byte[] privKeyByte = baos.toByteArray();
	        // get the public key from bytes
	        KeyFactory keyFactory = KeyFactory.getInstance("DSA");
	        EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(privKeyByte);
	        privKey = keyFactory.generatePrivate(privateKeySpec);
	    } catch (IOException e) {
			SpagoBITracer.major("SPAGOBI",
								this.getClass().getName(),
								"getPrivateKeyDSA",
								"Error loading the key file", e);
		} catch (NoSuchAlgorithmException e) {
			SpagoBITracer.major("SPAGOBI",
					this.getClass().getName(),
					"getPrivateKeyDSA",
					"Security alghoritm not found ", e);
		} catch (InvalidKeySpecException e) {
			SpagoBITracer.major("SPAGOBI",
					this.getClass().getName(),
					"getPrivateKeyDSA",
					"Invalid Key", e);
		} finally {

	    }
		return privKey;
	}



	/**
	 * Generate a random array of bytes (1024 bits) using the SHA1PRNG alghoritm.
	 *
	 * @return Byte array filled with random byte
	 */
	public byte[] generateRandomChallenge() {
		byte[] challenge = null;
		try {
			SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
			// Get 1024 random bits
			challenge = new byte[1024];
			sr.nextBytes(challenge);
		} catch (NoSuchAlgorithmException e) {
			SpagoBITracer.major("ENGINES",
								this.getClass().getName(),
								"generateRandomChallenge",
								"Alghoritm SHA1PRNG not found ", e);
		}
		return challenge;
	}



	/**
	 * Encode a byte array using Base64 alghoritm.
	 *
	 * @param bytes bytes to encode
	 *
	 * @return String Base64 string of the bytes
	 */
	public String encodeBase64(byte[] bytes) {
		Base64.Encoder encoder = Base64.getEncoder();
		String encoded = encoder.encodeToString(bytes);
		return encoded;
	}



	/**
	 * Sign dsa.
	 *
	 * @param data the data
	 *
	 * @return the byte[]
	 */
	public byte[] signDSA(byte[] data) {
		byte[] signed = null;
		try {
			Signature sign = Signature.getInstance("DSA");
			PrivateKey privKey = getPrivateKeyDSA();
			sign.initSign(privKey);
			sign.update(data);
			signed = sign.sign();
		} catch (NoSuchAlgorithmException e) {
			SpagoBITracer.major("ENGINES",
								this.getClass().getName(),
								"signDSA",
								"Alghoritm DSA not avaiable ", e);
		} catch (InvalidKeyException e) {
			SpagoBITracer.major("ENGINES",
								this.getClass().getName(),
								"signDSA",
								"Key not valid ", e);
		} catch (SignatureException e) {
			SpagoBITracer.major("ENGINES",
								this.getClass().getName(),
								"signDSA",
								"Error during the sign phase ", e);
		} finally {

		}
		return signed;
	}

}
