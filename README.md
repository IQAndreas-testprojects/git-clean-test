I'm having some trouble with `git clean`, and I'm not sure if it's a bug, or if I'm doing something wrong.

One script is required, `reset-test.sh` which will copy the files needed for the tests from the `reset-files` directory (which you can do manually if you prefer, for instance, if you are a Windows user).

### TEST #1 - All of 'ignore' is removed

To prepare for the first test, run `./reset-test.sh 1` (or copy the files from `reset-files/test1` to the root of your directory).

As we begin, `.gitignore` looks like this:

```
ignore/no-forwardslash
ignore/no-wildcard/
ignore/wildcard/*
```

We can tell it's working properly, as all three directories (and their contents) are being ignored by GIT.

We want to get rid of that pesky `untracked-file`, so clean it up by running `git clean -d -f`. It should ignore the three directories in `ignore`, since they are specified in `.gitignore`, _right_? **WRONG!** The entire `ignore` folder and all its contents are removed; this is despite us not using the `-x` flag! That's a shame. Let's try to fix this.

### TEST #2 - None of 'ignore' is removed?

Let's try that again. First, run `./reset-test.sh 2`. `.gitignore` now explicitly ignores the entire `ignore` folder:

```
ignore
ignore/no-forwardslash
ignore/no-wildcard/
ignore/wildcard/*
```
Now run `git clean -d -f`. Great! The three folders are ignored, but we have another problem. In this case, `git clean` was doing it's job correctly, since we told it to ignore the entire `ignore` folder.

But what if we have a folder inside of `ignore` named `untracked-folder` was supposed to be deleted, but was not? (which in this case, we actually did) This still leaves us no way to define which files in `ignore` to ignore without manually defining them in `.gitignore`. I'm still not satisfied!


### TEST #3 - None of 'ignore' is removed?

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

Now we run `git clean -d -f`.


