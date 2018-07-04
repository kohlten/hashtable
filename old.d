import std.stdio : writeln;
import core.stdc.stdlib;
import std.random : uniform;
import std.array : split;
import std.file;
import std.string : toStringz;

//http://www.azillionmonkeys.com/qed/hash.html

string readFile(string filename)
{
	if (exists(filename) && isFile(filename))
		return readText(filename);
	throw new Exception("Failed to open file");
}

ulong get16Bits(char *d)
{
	return ((cast(ulong)((cast(const ubyte *)(d))[1])) << 8) + cast(ulong)(((cast(const ubyte *)(d))[0]));
}

ulong superFastHash(char *data, ulong len)
{
	ulong hash = len;
	ulong tmp;
	long rem;

	if (len <= 0 || data == null)
		return 0;
	rem = len & 3;
	len >>= 2;

	for (; len > 0; len--)
	{
		hash += get16Bits(data);
		tmp = (get16Bits(data + 2) << 11) ^ hash;
		hash = (hash << 16) ^ tmp;
		data += 2 * short.sizeof;
		hash += hash >> 11;
	}

	switch (rem)
	{
		case 3:
			hash += get16Bits(data);
			hash ^= hash << 16;
			hash ^= data[short.sizeof] << 18;
			hash += hash >> 11;
			break;
		case 2:
			hash += get16Bits(data);
            hash ^= hash << 11;
           	hash += hash >> 17;
            break;
        case 1: 
        	hash += *data;
            hash ^= hash << 10;
            hash += hash >> 1;
            break;
         default:
         	break;
	}

	hash ^= hash << 3;
	hash += hash >> 5;
	hash ^= hash << 4;
	hash += hash >> 17;
	hash ^= hash << 25;
	hash += hash >> 6;

	return hash;
}

class DynamicArray(T)
{
	private: 
		ulong len = 0;
		ulong overall = 0;
		ulong prev = 1;
		T* arr = null;

	ulong length()
	{
		return this.len;
	}

	ref T opIndex(ulong i)
	{
		assert(i < this.len, "Value is greater than the length");
		return this.arr[i];
	}

	T append(T val)
	{
		if (this.arr is null)
		{
			this.arr = cast(T*)malloc(this.prev * T.sizeof);
			this.prev *= 2;
			this.overall += prev;
		}
		else if (len + 1 > overall)
		{
			this.arr = cast(T*)realloc(this.arr, (this.overall + (this.prev * 2)) * T.sizeof);
			assert(this.arr, "Failed to allocate");
			this.prev *= 2;
			this.overall += prev;
		}
		this.arr[this.len] = val;
		this.len++;
		return val;
	}

	T remove(ulong i)
	{
		T* tmp = this.arr;
		ulong loc;
		T removed;

		if (this.len - 1 < this.overall - (this.prev / 2))
		{
			free(this.arr);
			this.prev /= 2;
			this.overall -= prev;
			this.arr = cast(T*)malloc(this.overall);
		}
		removed = tmp[i];
		foreach (iter; 0 .. this.len)
			if (iter != i)
				this.arr[loc++] = tmp[iter];
		this.len--;
		return removed;
	}

	~this()
	{
		free(this.arr);
	}
}

linkedList!T* newList(T)(string key, T val)
{
	linkedList!T* list = cast(linkedList!T*)malloc(linkedList!T.sizeof);
	assert(list, "Failed to allocate");
	list.val = val;
	list.key = key;
	list.next = null;
	return list;
}

void freeList(T)(linkedList!T* list)
{
	while (list)
	{
		linkedList!T* node = list.next;
		free(list);
		list = node;
	}
	list = null;
}

struct linkedList(T)
{
	T val;
	string key;
	linkedList!T *next = null;

	~this()
	{
		freeList(&this);
	}
}	

class HashTable(T)
{
	private:
		linkedList!T*[] arr;

	this(ulong length = 50000)
	{
		this.arr.length = length;
	}

	T get(string key)
	{
		ulong hash = this.hash(key);
		linkedList!T *tmp = this.arr[hash];
		while (tmp)
		{
			if (tmp.key == key)
				return tmp.val;
			tmp = tmp.next;
		}
		assert(tmp, "Unable to find value");
		return tmp.val;
	}

	T assign(string key, T val)
	{
		ulong hash = this.hash(key);
		linkedList!T *tmp = this.arr[hash];
		if (!(tmp is null))
		{
			do
			{
				if (tmp.key == key)
					assert(0, "Already exists");
				if (!(tmp.next is null))
					tmp = tmp.next;
			} while (tmp.next);
			tmp.next = newList(key, val);
		}
		else
			this.arr[hash] = newList(key, val);
		return val;
	}

	ulong hash(string key)
	{
		ulong hash = superFastHash(cast(char *)key.toStringz, key.length - 1);
		return hash % this.arr.length;
	}

	~this()
	{
		foreach (i; 0 .. this.arr.length)
			if (!(this.arr[i] is null))
				freeList(this.arr[i]);
	}

}
