+ Array {
    breakAndNormalize { |targetSum|
        if(this.sum.abs < 0.001, { ^this }); // Avoid division by zero
        ^this * targetSum / this.sum;
    }
}








