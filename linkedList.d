import core.stdc.stdlib;
import std.stdio : stdout, writeln;
import std.conv : to;

struct DoubleLinkedList(T)
{
	T data;
	DoubleLinkedList!T *next = null;
	DoubleLinkedList!T *prev = null;
}

DoubleLinkedList!T* newDoubleNode(T)(T data, DoubleLinkedList!T* prev = null, DoubleLinkedList!T* next = null)
{
	DoubleLinkedList!T* list = cast(DoubleLinkedList!T*)malloc(DoubleLinkedList!T.sizeof);
	assert(list, "Failed to allocate");
	list.data = data;
	list.next = next;
	list.prev = prev;
	return list;
}

unittest
{
	writeln("Double Linked list basic test");
	DoubleLinkedList!int* list;
	DoubleLinkedList!int* tmp = list;
	DoubleLinkedList!int* prev = null;

	foreach (i; 0 .. 10)
	{
		tmp = newDoubleNode!int(i, prev);
		prev = tmp;
		tmp = tmp.next;
	}
	tmp = list;
	int data = 0;
	while (tmp)
	{
		assert(tmp.data == data, "Failed! Data is supposed to be " ~ 
			   to!string(data) ~ " and I got " ~ to!string(tmp.data));
		tmp = tmp.next;
		data++;
	}
	freeList!(int, DoubleLinkedList!int*)(list);
}

void freeList(L)(L list)
{
	L node;
	while (list)
	{
		node = list.next;
		free(list);
		list = node;
	}
	list = null;
}

DoubleLinkedList!T* removeDoubleListNode(T)(DoubleLinkedList!T* list, T key)
{
	DoubleLinkedList!T* node = list;
	DoubleLinkedList!T* prev;
	DoubleLinkedList!T* future;

	writeln(node.data, " ", key);
	while (node)
	{
		if (node)
			future = node.next;
		else
			future = null;
		writeln("Future: ", future, " ", node.next);
		if (node.data == key)
			break;
		prev = node;
		node = node.next;
	}
	writeln("Got node: ", node);
	if (node)
	{
		if (node == list)
		{
			writeln("Setting head to next node ", list, " ", future);
			list = future;
		}
		free(node);
		if (prev)
		{
			prev.next = future;
			future.prev = prev;
		}
	}
	writeln(list);
	return list;
}

unittest
{
	writeln("Remove Double node test");
	DoubleLinkedList!int* list = newDoubleNode(0);
	DoubleLinkedList!int** tmp = &list;
	DoubleLinkedList!int* prev;

	foreach (i; 1 .. 10)
	{
		(*tmp).next = newDoubleNode!int(i, prev);
		prev = (*tmp);
		*tmp = (*tmp).next;
	}
	writeln("List:", list);
	printList!(int, DoubleLinkedList!int*)(list);
	list = removeDoubleListNode!int(list, 0);
	assert(list.data != 0, "Node still in place");
	assert(list.next, "Failed to place next node in place");
	assert(list.next.data == 1, "Failed to get correct data in next");
	*tmp = list;
	int data = 0;
	while (tmp)
	{
		assert((*tmp).data == data, "Failed! Data is supposed to be " ~ 
			   to!string(data) ~ " and I got " ~ to!string((*tmp).data));
		*tmp = (*tmp).next;
		data++;
	}
	freeList!(int, DoubleLinkedList!int*)(list);
}

DoubleLinkedList!T* insertDouble(T)(DoubleLinkedList!T* list, T data, ulong pos)
{
	ulong current;
	DoubleLinkedList!T* tmp = list;
	DoubleLinkedList!T* prev;
	DoubleLinkedList!T* insertedNode = newDoubleNode(data);

	while (list && current < pos)
	{
		prev = tmp;
		tmp = tmp.next;
		current++;
	}
	prev.next = insertedNode;
	insertedNode.prev = prev;
	insertedNode.next = tmp;
	tmp.prev = insertedNode;
	return list;
}

struct LinkedList(T)
{
	T data;
	LinkedList!T *next = null;
}

LinkedList!T* newNode(T)(T data, LinkedList!T* next = null)
{
	LinkedList!T* list = cast(LinkedList!T*)malloc(LinkedList!T.sizeof);
	assert(list, "Failed to allocate");
	list.data = data;
	list.next = next;
	return list;
}	

LinkedList!T* removeListNode(T)(LinkedList!T* list, T key)
{
	LinkedList!T* node = list;
	LinkedList!T* prev;
	LinkedList!T* future;

	while (node)
	{
		if (node)
			future = node.next;
		else
			future = null;
		writeln("Future: ", future, " ", node.next);
		if (node.data == key)
			break;
		prev = node;
		node = node.next;
	}
	writeln("Got node: ", node);
	if (node)
	{
		if (node == list)
		{
			writeln("Setting head to next node ", list, " ", future);
			list = future;
		}
		free(node);
		if (prev)
			prev.next = future;
	}
	else
		assert(node, "Failed to find key " ~ to!string(key));
	writeln(list);
	return list;
}

LinkedList!T* insert(T)(LinkedList!T* list, T data, ulong pos)
{
	ulong current;
	LinkedList!T* tmp = list;
	LinkedList!T* prev;
	LinkedList!T* insertedNode = newNode(data);

	while (tmp && current < pos)
	{
		prev = tmp;
		tmp = tmp.next;
		current++;
	}
	
	if (list)
	{
		prev.next = insertedNode;
		insertedNode.next = tmp;
	}
	else
		list = insertedNode;
	return list;
}

void printList(L)(L list)
{
	L tmp = list;

	stdout.write("[");
	while (tmp)
	{
		stdout.write(to!string(tmp.data));
		if (tmp.next)
			stdout.write(", ");
		tmp = tmp.next;
	}
	stdout.write("]\n");
}



