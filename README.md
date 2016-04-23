#Overview

I came up with a greedy, almost-perfect solution and implemented it in about 2.5 hours. That solution is implemented as the tail-recursive `make_greedy_change` method. It works to find the least amount of coins to make change with American denominations, but fails on a denomination set like `[10, 8, 1]`

A couple days later, the basis for the complete solution hit me. I call this the "Patient Algorithm." It looks ahead and tries to make change in multiple possible ways at each iteration. I spent a few hours turining it into a working recursive solution. That solution is implemented as the `make_patient_change` method.

Now that I've implemented the recursive solution, I have an idea for how to make it efficiently tail-recursive.

* [Greedy Algorithm](#greedy-algorithm)
* [Patient Algorithm](#patient-algorithm)

# <a name="greedy-algorithm">Greedy Algorithm</a>

##Plain-English Algorithm

I've worked as a cashier enough times to have discovered the algorithm for making change with American money denominations:

###Imprecise Algorithm Description
> Make as much change with higher denominations first. When you can't get any closer
without going over, move to the next largest denomination.

##Initial Pseudo-Code Solution

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

##Fancier Stuff

I was interested to see if I could get fancier with some functional programming. I considered using a higher_order function and realized the difficulty there was that I would be producing more values than the original denominations list contained (not a one-to-one mapping from input to output).

I realized there was a flat_map function and that it would solve my problem if my inner function returned lists of the same coin denomination.

#The Problem with a Functional Solution

While learning about Ruby higher-order functions, I temporarily overlooked the inherent difficulty with coding this in a functional style: each iteration is not independent of the previous.

##The solution: Recursion

As soon as I realized why higher-order functions were a bad idea (they would require globals or C++ style pass-by-reference, which it seemed Ruby didn't have), I realized I could use recursion.

A tail recursive solution won't fill up the stack with a properly optimized compiler and it also can be memo-ized.

My final solution is the tail-recursive approach.

##The Results: 6 examples, 1 failure

Why one failure?

Difficult Math!

My algorithm works for American money denominations. American denominations have a convenient property:

```
For each denomonitaion d(i), the ith smallest denomination, 2 * d(i - 1) < d(i)
```

What this means is that you can't run into the problem where you can use a smaller set of coins by not using my greedy algorithm.

Test case #5 gives a denomination set that breaks this property, and thus, my algorithm.

A general-purpose solution is possible and has been implemented as [Patient Algorithm](#patient-algorithm)

#<a name="patient-algorithm">Patient Algorithm</a>

##Attack Strategy

The method for tackling a Mathematical proof is a lot like the method for developing an Algorithm: 

1. Come up with an example that you can solve naturally
2. Codify your thought process

By natural processes, I can easily make change for `17 cents` with the least amount of coins from a denomination set like `[10, 8, 1]`

I could tell there was one instance of trickery in this set: I had to decide between using a `10` and using an `8`. I wanted to make a better example of this hard problem by having an amount and denomination set where I had to make such a decision twice.

###Example

> Make change for 148 cents using the denominations `100, 90, 68, 5, 4, 1`

####Greedy Solution

`[100, 5, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 1]`

Number of coins: 13

####Patient Solution

`[68, 68, 4, 4, 4]`

Number of coins: 5

This example requires using 68 instead of 100 or 90 _and_ using 4 instead of 5.

##Plain-English Algorithm

> At each step, do the 'greedy' solution but also look ahead to smaller denominations and do the same calculation on them as was done for the greedy step. Compare the two solutions and return the shortest.

##Partial Pseudo-Code Solution

My initial inspiration for this algorithm turned out to be not entirely correct: I thought it would be enough to look ahead just at the next smallest denomination. In fact, the algorithm needs to look at all the denominations at each step.

I am showing, here, the pseudo-code for the initial inspiration. After implementing this pseudo-code, I debugged my problem until I realized the key: Check all the denominations, not just the largest two.

```ruby
recurse(amount, denominations)

    greedy_result = alg(amount, denominations[0])
    patient_result = alg(amount, denominations[1])

    if greedy_result.length <= patient_result.length
        return greedy_result
    else
        return patient_result
    end
 end
```

##Recursive vs Tail-Recursive

This solution is recursive and not tail recursive because it makes two recursive calls and then combines the results. I have an idea for the tail recursive strategy for the patient algorithm

##Results: All passing!

The patient algorithm correctly calculates the miniumum number of coins needed to make change, even for the difficult denominations like [10, 8, 1]
