# TreeSpellChecker Algorithm
## Overview
The algorithm is designed to work on a dictionary that has a rooted tree structure.

The algorithm treats the problem as a hidden state system, which tries to identify the true state of the input. Due to typographical errors, the state of the input is a hidden version of the true system state.  Each word in the dictionary is mapped to a multi-dimensional state, with the first dimension being being the root, the second dimension being the next branch, and so on.  Each dimension is discrete with a finite number of elements.  The first dimension corresponds to the root, so only has one element.

The algorithm assumes the input state has the correct structure, and so generates the state of the input.  It starts with the root of the input word and maps it to the root element. It then looks at the value of second dimension of the input word and chooses closest elements of the possible second dimension elements.  It then continues to the third and higher dimensions. It terminates when it has worked out possible elements corresponding to the highest dimension of the input word.  At this point it has the possible elements at for each dimension of the input word. It then generates all possible legitimate states from these elements.  Finally it then compares the possible leaves at the end of these legitimate states with the leaf of the input word. From this process it produces suggested states.

## Accuracy
The accuracy of the algorithm was tested using the HumanTypo class. It simulates a human typist by assuming that errors are Poisson distributed at a rate of one typo per 20 characters. Typos can be either a deletion, an insertion, substitution or a transposition.

I ran 10,000 repititions on both the `test` directory of the ```did_you_mean``` gem and on the ```spec``` directory of the ```rspec-core``` gem.  

The results were as follows:
```
                               Minitest Summary                                
--------------------------------------------------------------------------------
 Method  |   First Time (%)    Mean Suggestions       Failures (%)              
--------------------------------------------------------------------------------
 Tree                98.0                1.1                 2.0                 
 Standard            98.1                2.2                 1.6                 
 Augmented           100.0                1.1                 0.0  
```
and
```
                               Rspec Summary                                
--------------------------------------------------------------------------------
 Method  |   First Time (%)    Mean Suggestions       Failures (%)              
--------------------------------------------------------------------------------
 Tree                94.7                1.0                 5.3                 
 Standard            98.2                4.2                 1.1                 
 Augmented           99.7                1.2                 0.2   
```
As well, I checked the results on the ```test``` directory with ```HumanTypo``` generating errors at three times the rate:
```
                Minitest Summary  (lambda = 0.15)                             
--------------------------------------------------------------------------------
 Method  |   First Time (%)    Mean Suggestions       Failures (%)              
--------------------------------------------------------------------------------
 Tree               88.9                1.0                 11.0                 
 Standard           95.0                1.4                 4.3                 
 Combined           99.0                1.0                 0.8                 
```
In all cases, the tree speller, when augmented by the standard spell checker performed with higher accuracy, and giving far fewer suggestions.

## Execution Speed

I tested the execution time on the ```test ``` directory:
```
Testing execution time of Standard
Average time (ms): 5.2

Testing execution time of Tree
Average time (ms): 1.1

Testing execution time of Augmented Tree
Average time (ms): 1.2
```
and on the ```spec``` directory
```

Testing execution time of Standard
Average time (ms): 40.6

Testing execution time of Tree
Average time (ms): 2.7

Testing execution time of Augmented Tree
Average time (ms): 4.5
```

I was surprised by how much faster the tree checker was compared to the standard checker. I think the reason is that the predominant computational load will scale with O(log n) where n is the total number of words in the dictionary. My reasoning is that the algorithm very quickly prunes out states as it moves through the dimensions.
## Augmentation option
Given the major difference in speed between the standard and tree checker, and the likelihood that the disparity will grow rapidly with the size of the dictionary, then I suspect for some applications, it will not be not practicable to augment the tree checker by using the standard checker when the tree checker fails to find a suggestion.  Accordingly, I have added an option, ```:augment?```. The default is nil, but if true, then the standard checker is used if there are no suggestions.
## Generation of Performance data
This is done using ```test/tree_spell/explore_test.rb```. This is not a proper test file in that there are no assertions in it. As well, it takes over ten minutes to run, accordingly, I have disabled it by setting the constant TREE_SPELL_EXPLORE to false at the top of the file.  To run the file, set TREE_SPELL_EXPLORE to true.  It is also possible to run quick assessments by using a smaller value of n_repeat in the various tests.
## Future Work
I have identified two categories of remaining errors. The first class is when one of the elements is corrupted to being very small. Then the standard checker does not suggest the correct element, e.g. if an element is ```core``` and it is reduced to ```co```, the standard speller will not make a suggestion.  The second class of error is when the structure of the word is broken because one of the separators has been removed.  I think it might be possible to remove the first type of error and dramatically reduce the second type of error in a future version. This would be done as follows:
- At each level, choose the dictionary element with the smallest distance.
- This will work well unless the structure is broken, in which case it could return a wildly wrong suggestion.
- To guard against this, the suggestion could be checked against the input word using the standard checker. If the standard checker rejects the suggestion, then it is assumed the structure is broken.
- A large proportion of the time, a broken structure will be just due to one separator missing, and the order of the elements will not be affected. Accordingly, the structure can be fixed by comparing the input elements with a concatenation of two levels of the dictionary elements.  It would be possible to use the same idea to fix more than one separator missing, but this could quickly become computationally expensive.
