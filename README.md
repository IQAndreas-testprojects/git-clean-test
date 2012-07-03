I'm having some trouble with `git clean`, and I'm not sure if it's a bug, or if I'm doing something wrong.

One script is required, `reset-test.sh` which will copy the files needed for the tests from the `reset-files` directory (which you can do manually if you prefer, for instance, if you are a Windows user).

### TEST #1 - All of 'ignore' is removed!

To prepare for the first test, run `./reset-test.sh 1` (or copy the files from `reset-files/test1` to the root of your directory).

As we begin, `.gitignore` looks like this:

```
ignore/no-forwardslash
ignore/no-wildcard/
ignore/wildcard/*
```

We can tell it's working properly, as all three directories (and their contents) are being ignored by GIT. You can test this yourself by running `git status` and seeing which files show up in the list.

We want to get rid of that pesky `untracked-file`, so clean it up by running `git clean -d -f`. It should ignore the three directories in `ignore`, since they are specified in `.gitignore`, _right_? **WRONG!** The entire `ignore` folder and all its contents are removed; this is despite us not using the `-x` flag! That's a shame. Let's try to fix this.

We could have tried `git clean -f` (without the `-d` flag) but that will leave the entire `ignore` folder, including all of its untracked contents.

### TEST #2 - None of 'ignore' is removed...

Let's try something else. First, run `./reset-test.sh 2`. `.gitignore` now explicitly ignores the entire `ignore` folder:

```
ignore
ignore/no-forwardslash
ignore/no-wildcard/
ignore/wildcard/*
```
Now run `git clean -d -f`. Great! The three folders are ignored, but we have another problem. In this case, `git clean` was doing it's job correctly, since we told it to ignore the entire `ignore` folder.

But what if we have a folder inside of `ignore` named `untracked-folder` was supposed to be deleted, but was not? (which in this case, we actually did) This still leaves us no way to define which files in `ignore` to ignore without manually defining them in `.gitignore`. I'm still not satisfied!


### TEST #3 - Some items from .gitignore are removed?

For kicks, let's add a tracked folder to the `ignore` file. Run `./reset-test.sh 3` which adds a new file for us to track, and reverts `.gitignore` back to looking like this:

```
ignore/no-forwardslash
ignore/no-wildcard/
ignore/wildcard/*
```

We need to add the file manually in git by running the following:

```
git add ignore/tracked-file
git commit -m "Added 'tracked-file'"
```

Now we get to the real reason I created these elaborate tests! Run `git clean -d -f`. 

```
$ git clean -d -f
Removing ignore/untracked-folder/
Removing ignore/wildcard/
Removing untracked-file
```

Good news is, it no longer deleted the entire `ignore` folder; it deleted all the untracked files and folders. 

Bad news is it also deleted `ignore/wildcard/` even though we specifically requested GIT to keep that folder in `gitignore`. 

After further thinking, it looks like we told GIT to keep the _contents_ of the folder. But we didn't tell `gitignore` to keep the folder itself, so it took it upon itself to remove it for us. _(sigh)_


### A conclusion

It's been a long day, and I'm tired of fiddling around with this. 

From what I can tell after the tests, clean removes **everything** not specifically named in `gitignore` (which is what it is supposed to do). Then problem is, even if a subfolder or file is defined in `gitignore`, unless its parent folder is defined as well, the subfolder will be removed along with its parent.

Second, don't use wildcards for folder contents in `gitignore` as the folder will still be eligible for "cleaning".

The only workaround I have found is to add tracked files into every untracked "parent folder", but that defies the whole purpose of ignoring them.

Is this how `git clean` is supposed to work, or am I using it incorrectly?


