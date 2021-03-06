/*
Knowage, Open Source Business Intelligence suite
Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.

Knowage is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

Knowage is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @authors Radmila Selakovic (radmila.selakovic@eng.it)
 *
 */
angular.module("customWidgetAPI",[]).service("datastore",function($filter){

	function datastore(data) {
		this.data = data;
	}


	var globalTree = [];
	function hierarchy(tree) {
		this.tree = tree;
		globalTree = tree;
	}

	function node (node){
		for (var property in node) {
			this[property] = node[property];
		}

	}
	datastore.prototype.setData = function (data) {
		this.data = transformDataStore(data);
	}

	datastore.prototype.getRecords = function () {
		return angular.copy(this.data.rows);
	}
	datastore.prototype.getDataArray = function (getDataArrayFn){
		var dataArray = [];
		for(var i=0; i<this.data.rows.length; i++){
			var dataObj = getDataArrayFn(this.data.rows[i]);
			dataArray.push(dataObj)
		}
		return dataArray;
	}

	datastore.prototype.getColumn = function (column){
		var categArray = [];
		for(var i=0; i<this.data.rows.length; i++){
			var dataObj = this.data.rows[i][column];
			if(categArray.indexOf(dataObj)==-1)
				categArray.push(dataObj)
		}
		return categArray;
	}

	datastore.prototype.getSeriesAndData = function (column,getDataArrayFn,datalabel){
		var seriesMap = {};
		for(var i=0; i<this.data.rows.length; i++){
			if(seriesMap[this.data.rows[i][column]]==undefined){
				seriesMap[this.data.rows[i][column]] = []
			}
			seriesMap[this.data.rows[i][column]].push(getDataArrayFn(this.data.rows[i]))
		}
		var series = []
		for (var property in seriesMap) {
			var serieObj = {};
			serieObj.name = property;
			serieObj.id = property;
			serieObj[datalabel || 'data'] = seriesMap[property];
			series.push(serieObj);
		}
		return series;
	}

	datastore.prototype.sort = function(sortingObject){
		var newData = angular.copy(this.data);
		if(typeof sortingObject == 'object'){
			sortingObject = (sortingObject[Object.keys(sortingObject)[0]]=='desc' ? "-" : "") +Object.keys(sortingObject)[0];
		}
		newData.rows = $filter('orderBy')(newData.rows, sortingObject);
		return new datastore(newData);
	},

	datastore.prototype.filter = function(filterObject, strict){
		var newData = angular.copy(this.data);
		newData.rows = $filter('filter')(newData.rows, filterObject, strict);
		return new datastore(newData);
	}

	datastore.prototype.hierarchy = function(config){
		var args = [];
		var paths = getHierarchyList(config,this.data )
		var tree = [];

		for (var i = 0; i < paths.length; i++) {
			var path = paths[i];
			var currentLevel = tree;
			for (var j = 0; j < path.length; j++) {
				var part = path[j];

				var existingPath = findWhere(currentLevel, 'name', part);

				if (existingPath) {
					currentLevel = existingPath.children;
				} else {
					var newPart = {
							name: part,
							children: [],
						}
					if(!(part instanceof Object)){
						if(path.length-j==2 && path[j+1]!=undefined && path[j+1] instanceof Object){
							for (var property in path[j+1]) {
								newPart[property] = Number(path[j+1][property])
							}
							j++
						}
						var n =  new node(newPart);
						currentLevel.push(n);
						currentLevel = newPart.children;
						if(path.length-j<2)break
					} else {
						for (var prop in part) {
							if(config.measures[prop].toLowerCase()=='max'){
								newPart[prop] = getMaxValue(part[prop], newPart[prop]);
							}
							else if(config.measures[prop].toLowerCase()=='min'){
								newPart[prop] = getMinValue(part[prop], newPart[prop]);
							}
							else if(config.measures[prop].toLowerCase()=='sum'){
								newPart[prop] = getSum(part[prop], newPart[prop]);
							}
						}

					}



				}
			}
		}

		var measures = config.measures;
		if(measures){
			countLevelsTotal(tree, measures)


		}
		return new hierarchy(tree);

		function findWhere(array, key, value) {
			t = 0; // t is used as a counter
			while (t < array.length && array[t][key] !== value) { t++; };

			if (t < array.length) {
				return array[t]
			} else {
				return false;
			}
		}

		function getMaxValue(part, newPart) {
			return Math.max(part, newPart);
		}

		function getMinValue(part, newPart) {
			return 	Math.min(part, newPart);
		}

		function getSum(part, newPart) {
			return part + newPart;
		}

		function getHierarchyList (args,data) {
			var array = [];

			var datastore = angular.copy(data);
			for(var i=0; i<datastore.rows.length; i++){
				var obj = {};
				for (var prop in datastore.rows[i]){
					if(args.measures!=undefined){
						if(args.levels.indexOf(prop)==-1 && !args.measures.hasOwnProperty(prop)){
							delete datastore.rows[i][prop]
						}
					} else {
						if(args.levels.indexOf(prop)==-1){
							delete datastore.rows[i][prop]
						}
					}
				}
			}
			for(var i=0; i<datastore.rows.length; i++){
				var obj = {};
				var newArray =[]
				var counter =0;

				for(var j=0; j<args.levels.length; j++){
					for (var property in datastore.rows[i]) {
						if(args.levels[j]==property){
							newArray.push(datastore.rows[i][property])
						}
					}
				}

				if(args.measures){
					for (var prop in args.measures) {
						for (var property in datastore.rows[i]) {
							if(prop==property){
								if(counter ==0){
									newArray.push({[property]:Number(datastore.rows[i][property])})
									counter++
								} else {
									newArray[newArray.length-1][property] = Number(datastore.rows[i][property])
								}
							}
						}
					}
				}

				array.push(newArray);
			}
			return array;

		}

		function countLevelsTotal (tree, measures){
			for (var prop in measures) {
				tree.reduce(function x(r, a) {
					a[prop] = a[prop] || Array.isArray(a.children) && a.children.reduce(x, 0) || 0;
					if(measures[prop].toLowerCase()=='max'){
						return getMaxValue(r, a[prop]);
					}
					else if(measures[prop].toLowerCase()=='min'){
						if(r!=0) return getMinValue(r, a[prop]);
						else return a[prop];
					}
					else if(measures[prop].toLowerCase()=='sum'){
						return getSum(r, a[prop]);
					}
				}, 0);
			}
		}


	}

	hierarchy.prototype.getChild = function(index){
		return this.tree[index];
	//	this.tree
	}

	hierarchy.prototype.getLevel = function(level){
		var nodes = [];
		for (var j=0; j<this.tree.length; j++) {
			var depth = 0;
			if(level == depth){
				nodes.push(this.tree[j]);
			}else{
				deeperLevel(this.tree[j],depth + 1);
			}
		}

		function deeperLevel(tree,depth){
			var children = tree.children;
			for (var i=0; i<children.length; i++) {
				if(depth == level){
					nodes.push(children[i]);
				}else{
					deeperLevel(children[i],depth + 1);
				}
			}
		}

		return nodes;
	}

	node.prototype.getValue = function (measure) {
		return this[measure];
	}

	node.prototype.getChild = function (index) {
		return this.children[index];
	}

	var traverseDF = function(tree,callback){
		(function recurse(currentNode){

			callback(currentNode);
			if(!Array.isArray(currentNode)){
				for(var i = 0; i <currentNode.children.length;i++){
					recurse(currentNode.children[i]);
				}
			} else {
				for(var j = 0; j <currentNode.length;j++){
					recurse(currentNode[j]);
				}
			}


		})(tree)
	}
	var contains = function(tree,nodeToFind){
		var contains = false;
		traverseDF(tree,function(node){

			if(node === nodeToFind){
				contains = true
			};
		})

		return contains;
	}

	var nodeExistingCheck = function(tree,node){

		if(!contains(tree,node)){

			throw new Error('Node does not exist.');
		}
	}

	node.prototype.getParent = function () {
		var parent;
		var child = this;
		nodeExistingCheck(globalTree,child)

		traverseDF(globalTree,function(node){


			if(!Array.isArray(node)){
				if(findElementIndex(node.children,child)>-1)parent = node;
			} else {
				for(var j = 0; j <node.length;j++){
					if(findElementIndex(node[j],child)>-1)parent = node[j];
				}
			}


		})
//new node
		return parent;
	}

	node.prototype.getChildren = function () {
		return this.children
	}

	node.prototype.getSiblings = function () {
		return this.getParent().children;
	}

	var findElementIndex = function(array,element){
		for(var i =0;i<array.length;i++){
			if(element===array[i]){
				return i;
			}
		}
	}


	return new datastore;

	function transformDataStore (datastore){
		var newDataStore = {};
		newDataStore.metaData = datastore.metaData;
		newDataStore.results = datastore.results;
		newDataStore.rows = [];

		for(var i=0; i<datastore.rows.length; i++){
			var obj = {};
			for(var j=1; j<datastore.metaData.fields.length; j++){
				if(datastore.rows[i][datastore.metaData.fields[j].name]!=undefined){
					obj[datastore.metaData.fields[j].header] = datastore.rows[i][datastore.metaData.fields[j].name];
				}
			}
			newDataStore.rows.push(obj);
		}
		return newDataStore;
	}
});