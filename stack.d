import linkedList;

import std.stdio;

class Stack(T)
{
private:
	LinkedList!T *arr;
	ulong length;

public:
	this()
	{

	}

	void push(T val)
	{
		this.arr = insert!(T)(this.arr, val, 0);
		this.length++;
		writeln(this.length);
	}

	T pop()
	{
		T data = arr.data;
		this.arr = removeListNode!(T)(this.arr, data);
		this.length--;
		return data;
	}

	ulong getLen()
	{
		return this.length;
	}

	~this()
	{}
}