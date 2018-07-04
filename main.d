import dynamicArray;
import linkedList;
import hashtable;

import std.stdio;
import std.conv;

void testArray()
{
	DynamicArray!int arr;
	int[] copy;

	writeln("Testing array");
	arr = new DynamicArray!int;

	foreach (i; 0 .. 100000)
	{
		arr.append(i);
		copy ~= (i);
	}
	foreach(i; 0 .. 100000)
		assert(arr[i] == copy[i], "Failed to append");
}

void testLinkedList()
{
	LinkedList!int *list = newNode(-1);
	LinkedList!int **tmp = &list;

	writeln("Testing linked list");
	foreach (i; 0 .. 100)
	{
		(*tmp).next = newNode(i);
		tmp = &((*tmp).next);
	}
	printList(list);
	tmp = &list;
	foreach (i; -1 .. 100)
	{

		assert((*tmp).data == i);
		tmp = &((*tmp).next);
	}
	list = removeListNode!(int)(list, -1);
	tmp = &list;
	foreach (i; 0 .. 100)
	{

		assert((*tmp).data == i);
		tmp = &((*tmp).next);
	}
	list = removeListNode!(int)(list, 5);
	tmp = &list;
	printList(list);
	foreach (i; 0 .. 100)
	{
		writeln((*tmp).data, " ", i);
		if (i == 5)
			continue;
		assert((*tmp).data == i, "Unkown Variable");
		tmp = &((*tmp).next);
	}
	list = insert!int(list, 5, 5);
	tmp = &list;
	foreach (i; 0 .. 100)
	{

		assert((*tmp).data == i);
		tmp = &((*tmp).next);
	}
	printList(list);
	freeList(list);
}

void testDoubleLinkedList()
{
	DoubleLinkedList!int *list = newDoubleNode(-1);
	DoubleLinkedList!int **tmp = &list;

	writeln("Testing DoubleLinkedList");
	foreach (i; 0 .. 100)
	{
		(*tmp).next = newDoubleNode(i);
		tmp = &((*tmp).next);
	}
	printList(list);
	tmp = &list;
	foreach (i; -1 .. 100)
	{

		assert((*tmp).data == i);
		tmp = &((*tmp).next);
	}
	list = removeDoubleListNode!(int)(list, -1);
	tmp = &list;
	foreach (i; 0 .. 100)
	{

		assert((*tmp).data == i);
		tmp = &((*tmp).next);
	}
	list = removeDoubleListNode!(int)(list, 5);
	tmp = &list;
	printList(list);
	foreach (i; 0 .. 100)
	{
		writeln((*tmp).data, " ", i);
		if (i == 5)
			continue;
		assert((*tmp).data == i, "Unkown Variable");
		tmp = &((*tmp).next);
	}
	list = insertDouble!int(list, 5, 5);
	tmp = &list;
	foreach (i; 0 .. 100)
	{

		assert((*tmp).data == i);
		tmp = &((*tmp).next);
	}
	printList(list);
	freeList(list);
}

void testHashTable()
{
	HashTable!int dict;
	int[string] copy;

	dict = new HashTable!int;
	foreach (i; 0 .. 100)
	{
		int val = cast(int)i;
		string key = to!string(i);
		dict.assign(key, val);
		copy[key] = val;
	}
	foreach (key, val; copy)
		assert(dict.get(key) == val);
}

void main()
{
	testArray();
	testLinkedList();
	testDoubleLinkedList();
}