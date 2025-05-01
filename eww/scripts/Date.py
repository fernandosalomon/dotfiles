#!/usr/bin/env python3

from datetime import datetime
import sys


def main():
     
    date = datetime.today().strftime('%A, %d %B')
    time = datetime.today().strftime('%H:%M')
    monthYear = datetime.today().strftime('%B %C%g')

    # Check user options
    if len(sys.argv) != 2:
        print("Error: Argument Missing")
        return

    option = sys.argv[1]

    if(option == '--date'):
        print(date)
    elif(option == '--time'):
        print(time)
    elif(option == '--month-year'):
        print(monthYear)
    else:
        print("")
    


if __name__ == "__main__":
    main()