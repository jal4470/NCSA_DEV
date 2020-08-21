/** 
* Copyright 2006 massimocorner.com
* License: http://www.massimocorner.com/license.htm
* @author      Massimo Foti (massimo@massimocorner.com)
* @version     0.2.6, 2006-12-12
 */

if(typeof(tmt) == "undefined"){
	var tmt = {};
}

/**
* Developed by John Resig
* For additional info see:
* http://ejohn.org/projects/flexible-javascript-events
*/
tmt.addEvent = function(obj, type, fn){
	if(obj.addEventListener){
		obj.addEventListener(type, fn, false);
	}
	else if(obj.attachEvent){
		obj["e" + type + fn] = fn;
		obj[type + fn] = function(){
				obj["e" + type + fn](window.event);
			}
		obj.attachEvent("on" + type, obj[type+fn]);
	}
}

/**
* Equivalent of the famous $() function. Just with a better name :-)
*/
tmt.get = function(){
	var returnNodes = new Array();
	for(var i=0; i<arguments.length; i++){
		var nodeElem = arguments[i];
		if(typeof nodeElem == "string"){
			nodeElem = document.getElementById(nodeElem);
		}
		if(arguments.length == 1){
			return nodeElem;
		}
		returnNodes.push(nodeElem);
	}
	return returnNodes;
}

/**
* Return an array containing all child nodes. 
* If no starting node is passed, assume the document is the starting point
*/
tmt.getAll = function(startNode){
	// If no node was passed, use the document
	var rootNode = (startNode) ? tmt.get(startNode) : document;
	return rootNode.getElementsByTagName("*");
}

/**
* Return an array containing all child nodes. 
* Unlike tmt.getAll, it return only elements of type Node.NODE_ELEMENT, no comments or other kind of nodes
* If no starting node is passed, assume the document is the starting point
*/
tmt.getAllNodes = function(startNode){
	var elements = tmt.getAll(startNode);
	var nodesArray = [];
	for(var i=0; i<elements.length; i++){
		if(elements[i].nodeType == 1){
			nodesArray.push(elements[i]);
		}
	}
	return nodesArray;
}

/**
* Return an array containing all child nodes that contain the given attribute 
* If no starting node is passed, assume the document is the starting point
*/
tmt.getNodesByAttribute = function(attName, startNode){
	var nodes = tmt.getAll(startNode);
	return tmt.filterNodesByAttribute(attName, nodes);
}

/**
* Return an array containing all child nodes that contain the given attribute matching a given value
* If no starting node is passed, assume the document is the starting point
*/
tmt.getNodesByAttributeValue = function(attName, attValue, startNode){
	var nodes = tmt.getAll(startNode);
	return tmt.filterNodesByAttributeValue(attName, attValue, nodes);
}

/**
* Out of a node list, return an array containing all nodes that contain the given attribute
*/
tmt.filterNodesByAttribute = function(attName, nodes){
	var filteredNodes = new Array();
	for(var i=0; i<nodes.length; i++){
		if(nodes[i].getAttribute(attName)){
			filteredNodes.push(nodes[i]);
		}
	}
	return filteredNodes;
}

/**
* Out of a node list, return an array containing all nodes that contain the given attribute matching a given value
*/
tmt.filterNodesByAttributeValue = function(attName, attValue, nodes){
	var filteredNodes = new Array();
	for(var i=0; i<nodes.length; i++){
		if(nodes[i].getAttribute(attName) && (nodes[i].getAttribute(attName) == attValue)){
			filteredNodes.push(nodes[i]);
		}
	}
	return filteredNodes;
}

/**
* Set the value of an attribute on a list of nodes (accept both a node id or node object)
*/
tmt.setNodeAttribute = function(nodeList, attName, attValue){
for(var i=0; i<nodeList.length; i++){
		var nodeElem = tmt.get(nodeList[i]);
		if(nodeElem){
			nodeElem[attName] = attValue;
		}
	}
}

tmt.trim = function(str){
	return str.replace(/^\s+|\s+$/g, "");
}

/**
* Replace special XML character with the equivalent entities
*/
tmt.encodeEntities = function(str){
	if(str && str.search(/[&<>"]/) != -1){
		str = str.replace(/&/g, "&amp;");
		str = str.replace(/</g, "&lt;");
		str = str.replace(/>/g, "&gt;");
		str = str.replace(/"/g, "&quot;");
	}
	return str
}

/**
* Replace XML's entities with the equivalent character
*/
tmt.unencodeEntities = function(str){
	str = str.replace(/&amp;/g, "&");
	str = str.replace(/&lt;/g, "<");
	str = str.replace(/&gt;/g, ">");
	str = str.replace(/&quot;/g, '"');
	return str
}