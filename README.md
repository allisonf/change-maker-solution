#Plain-English Algorithm

I've worked as a cashier enough to know the algorithm for making change with American money denominations:

_Imprecise Algorithm Description_
> Make as much change with higher denominations first. When you can't get any closer
without going over, move to the next largest denomination.

#Initial Pseudo-Code solution

I first tried a straight-forward approach. I've written a partial solution in a Groovy/Ruby hybrid:

```groovy
change_array = []
change_total = 0
denomination_index = 0
	while (change_total < amount && denomination_index < denomination.size()) {
		if ((amount - change_total) < change_array[denomination_index]) {
		amount += change_array[denomination_index]
	} else {
		denomination_index += 1
	}

	if (change_total != amount) {
		raise ChangeError
	}
}
```

#Fancier Stuff

I was interested to see if I could get fancier with some functional programming. I considered using a higher_order function and realized the difficulty there was that I would be producing more values than the original denominations list contained (not a one-to-one mapping from input to output).

I realized there was a flat_map function and that it would solve my problem if my inner function returned lists of the same coin denomination.

#The Problem with a Functional Solution

While learning about Ruby higher-order functions, I temporarily overlooked the inherent difficulty with coding this in a functional style: each iteration is not independent of the previous.

#Recursion: The solution

As soon as I realized why higher-order functions were a bad idea (they would require globals or C++ style pass-by-reference, which it seemed Ruby didn't have), I realized I could use recursion.

A tail recursive solution may fill up the stack, but it also can be memo-ized.

My final solution is the tail-recursive approach.
