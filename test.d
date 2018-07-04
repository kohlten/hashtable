import std.random : uniform;
import std.random : uniform;
import std.array : split;
import std.file;

import	hashtable,
		dynamicArray;

string readFile(string filename)
{
	if (exists(filename) && isFile(filename))
		return readText(filename);
	throw new Exception("Failed to open file");
}

void main()
{
	DynamicArray!string arr;
	string[] copy;
	//HashTable!int dict;
	string[] words;
	//int[string] vals;

	arr = new DynamicArray!string;
	//dict = new HashTable!int(20);
	words = readFile("words.txt").split("\n");

	/*foreach (i; 0 .. 10)
	{
		int val = cast(int)i;
		string key = words[i];
		dict.assign(key, val);
		vals[key] = val;
	}
	foreach (key, val; vals)
		assert(dict.get(key) == val);*/
	foreach (i; 0 .. words.length)
	{
		arr.append(words[i]);
		copy ~= words[i];
		writeln("Values: ", arr[i], " ", copy[i]);
	}
	foreach (i; 0 .. arr.length)
	{
		writeln(arr[i], " ", copy[i]);
		assert(arr[i] == copy[i], "Failed to get values");
	}
}