using Base.Test
using NPZ

Debug = false

tmp = mktempdir()
if Debug
	println("temporary directory: $tmp")
end

TestArrays = {
	true,
	false,
	int8(-42),
	int16(-42),
	int32(-42),
	int64(-42),
	uint8(42),
	uint16(42),
	uint32(42),
	uint64(42),
	float32(3.1415),
	float64(3.1415),
	complex64(1, 7),
	complex128(1, 7),
	Bool[0, 1, 0, 1, 1, 0],
	Int8[-42, 0, 1, 2, 3, 4],
	Int16[-42, 0, 1, 2, 3, 4],
	Int32[-42, 0, 1, 2, 3, 4],
	Int64[-42, 0, 1, 2, 3, 4],
	Uint8[0, 1, 2, 3, 4],
	Uint16[0, 1, 2, 3, 4],
	Uint32[0, 1, 2, 3, 4],
	Uint64[0, 1, 2, 3, 4],
	Float64[-42, 0, 1, 2, 3.14, 4],
	Float32[-42, 0, 1, 2, 3.14, 4],
	Complex64[1+2im, 3, 4+5im, 6im, 7+8im],
	Complex128[1+2im, 3, 4+5im, 6im, 7+8im],
	[i-j for i in 1:3, j in 1:5],
	[i-j+k for i in 1:3, j in 1:4, k in 1:5],
}

# Write a NPZ file with all the test arrays and numbers,
# and read it back in.
old = (String => Any)[]
for (i, x) in enumerate(TestArrays)
	old["testvar_" * dec(i)] = x
end
filename = "$tmp/big.npz"
npzwrite(filename, old)
new = npzread(filename)
for (k, v) in old
	@test v == new[k]
end
@test old == new


# Write and then read NPY files for each array
for x in TestArrays
	filename = "$tmp/test.npy"
	npzwrite(filename, x)
	y = npzread(filename)
	@test typeof(x) == typeof(y)
	@test size(x) == size(y)
	@test x == y
end


if !Debug
	run(`rm -rf $tmp`)
end
