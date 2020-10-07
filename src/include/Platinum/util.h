#ifndef util_h__
#define util_h__

template <typename T>
class Property {
public:
	virtual ~Property() {}
	virtual T& operator= (const T& f) { return value = f; }
	virtual const T& operator() () const { return value; }
	virtual explicit operator const T& () const { return value; }
	virtual T* operator->() { return &value; }
protected:
	T value;
};

template <typename T>
class ImmutProp {
public:
	virtual ~ImmutProp() {};
	virtual operator T const & () const { return value; }
protected:
	T value;
};

#endif