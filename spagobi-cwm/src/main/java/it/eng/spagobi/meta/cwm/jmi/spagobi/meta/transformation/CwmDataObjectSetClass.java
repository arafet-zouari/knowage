package it.eng.spagobi.meta.cwm.jmi.spagobi.meta.transformation;

import it.eng.spagobi.meta.cwm.jmi.spagobi.meta.core.VisibilityKind;
import javax.jmi.reflect.RefClass;

public abstract interface CwmDataObjectSetClass
  extends RefClass
{
  public abstract CwmDataObjectSet createCwmDataObjectSet();
  
  public abstract CwmDataObjectSet createCwmDataObjectSet(String paramString, VisibilityKind paramVisibilityKind);
}
