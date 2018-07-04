import core.stdc.stdlib;
import core.stdc.string;
import core.memory : GC;
import std.stdio;

class DynamicArray(T)
{
private: 
	ulong len = 0;
	ulong overall = 0;
	ulong prev = 1;
	T* arr = null;

public:
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
		if (len + 1 >= overall || !this.arr)
		{
			if (!this.arr)
				this.arr = cast(T*)GC.malloc((this.overall + (this.prev * 2)) * T.sizeof);
			else
				this.arr = cast(T*)GC.realloc(this.arr, (this.overall + (this.prev * 2)) * T.sizeof);
			assert(this.arr, "Failed to allocate");
			this.overall += prev;
			this.prev *= 2;
		}
		this.arr[this.len] = val;
		this.len++;
		return val;
	}

	T remove(ulong i)
	{
		T* tmp;
		ulong loc;
		T removed;

		if (this.len - 1 < this.overall - (this.prev / 2))
		{
			free(this.arr);
			this.overall -= prev;
			this.prev /= 2;
			this.arr = cast(T*)GC.malloc(this.overall);
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
		GC.free(this.arr);
	}
}