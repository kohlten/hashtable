import std.stdio : writeln, stdout;
import core.stdc.stdlib;
import std.string : toStringz;
import std.typecons;
import linkedList;

//http://www.azillionmonkeys.com/qed/hash.html

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

class HashTable(T)
{
private:
	LinkedList!(Tuple!(string, "key", T, "val"))*[] arr;
	ulong count;
public:
	this(ulong length = 4)
	{
		this.arr.length = length;
	}

	T get(string key)
	{
		ulong hash = this.hash(key, this.arr.length);
		LinkedList!(Tuple!(string, "key", T, "val")) *tmp = this.arr[hash];
		while (tmp)
		{
			if (tmp.data.key == key)
				return tmp.data.val;
			tmp = tmp.next;
		}
		assert(tmp, "Unable to find value");
		return tmp.data.val;
	}

	void remove(string key)
	{
		ulong hash = this.hash(key, this.arr.length);
		LinkedList!(Tuple!(string, "key", T, "val")) *tmp = this.arr[hash];
		while (tmp)
		{
			if (tmp.data.key == key)
				break;
			tmp = tmp.next;
		}
		this.count--;
		this.arr[hash] = removeListNode!(Tuple!(string, "key", T, "val"))(tmp, tmp.data);
	}

	T assign(string key, T val)
	{
		assert(key != "", "Empty key");
		ulong hash = this.hash(key, this.arr.length);
		LinkedList!(Tuple!(string, "key", T, "val")) *tmp = this.arr[hash];

		if (!(tmp is null))
		{
			do
			{
				if (tmp.data.key == key)
				{
					tmp.data.val = val;
					return val;
				}
				if (!(tmp.next is null))
					tmp = tmp.next;
			} while (tmp.next);
			tmp.next = newNode(tuple!(string, "key", T, "val")(key, val));
			this.count++;
		}
		else
			this.arr[hash] = newNode(tuple!(string, "key", T, "val")(key, val));
		if (this.count > ((this.arr.length / 4) * 3))
			this.resize();
		return val;
	}

	ulong hash(string key, ulong length)
	{
		ulong hash = superFastHash(cast(char *)key.toStringz, key.length - 1);
		return hash % length;
	}

	string[] keys()
	{
		string[] listKeys;

		foreach (node; this.arr)
		{
			auto tmp = node;
			writeln(tmp);
			while (tmp)
			{
				writeln(tmp.data.key);
				listKeys ~= tmp.data.key;
				tmp = tmp.next;
			}
		}
		return listKeys;
	}

	T[] values()
	{
		T[] listValues;

		foreach (node; this.arr)
		{
			auto tmp = node;
			while (tmp)
			{
				listValues ~= tmp.data.val;
				tmp = tmp.next;
			}
		}
		return listValues;
	}

	Tuple!(string, "key", T, "val")[] items()
	{
		Tuple!(string, "key", T, "val")[] listItems;

		foreach (node; this.arr)
		{
			auto tmp = node;
			while (tmp)
			{
				listItems ~= tmp.data;
				tmp = tmp.next;
			}
		} 
		return listItems;
	}

	void printHash()
	{
		auto items = this.items();
		stdout.write("{");
		foreach (i; 0 .. items.length)
		{
			stdout.write("\"", items[i].key, "\":", items[i].val);
			if (i < this.items.length - 1)
				stdout.write(" ");
		}
		stdout.write("}\n");
	}

	ulong size()
	{
		return this.count;
	}

	ulong[] countArrayItems()
	{
		ulong[] counts;
		ulong pos;

		counts.length = this.arr.length;
		foreach (node; this.arr)
		{
			auto tmp = node;
			while (tmp)
			{
				counts[pos]++;
				tmp = tmp.next;
			}
			pos++;
		}
		return counts;
	}

private:
	T assign(string key, T val, LinkedList!(Tuple!(string, "key", T, "val"))*[] arr)
	{
		ulong hash = this.hash(key, arr.length);
		LinkedList!(Tuple!(string, "key", T, "val")) *tmp = arr[hash];
		if (!(tmp is null))
		{
			do
			{
				if (tmp.data.key == key)
				{
					tmp.data.val = val;
					writeln("Found and assigned a new value");
					return val;
				}
				if (!(tmp.next is null))
					tmp = tmp.next;
			} while (tmp.next);
			tmp.next = newNode(tuple!(string, "key", T, "val")(key, val));
		}
		else
			arr[hash] = newNode(tuple!(string, "key", T, "val")(key, val));
		return val;
	}

	void resize()
	{
		LinkedList!(Tuple!(string, "key", T, "val"))*[] newList;

		newList.length = this.arr.length * 2;
		foreach (item; this.items())
			this.assign(item.key, item.val, newList);

		this.free();

		this.arr = newList;
	}

	void free()
	{
		foreach (i; 0 .. this.arr.length)
			if (!(this.arr[i] is null))
				freeList(this.arr[i]);
	}

	~this()
	{
		this.free();
	}

}