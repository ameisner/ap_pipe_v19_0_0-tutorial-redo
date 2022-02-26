def _patches(n):
    # n x n set of patches

    result = ''
    for i in range(0, n):
        for j in range(0, n):
            pair = str(i)+','+str(j)
            result += pair
            if (i != (n-1)) | (j != (n-1)):
                result += '^'

    print(result)
            
