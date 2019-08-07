#! /usr/bin/python3
 
#Based on Ocean Treasure game
'''
    Space Aliens
 
    Simple game where you have to find Aliens lost  in space.
    Space is  represented by a grid of 50 by 50 rows and the Aliens
    can be  in any cell. To find a Aliens you
    need to drop radar devices.
 
    To play, click buttons to drop radar device.
    The radar reports the distance to the Aliens.
'''
 
import math
import random
import tkinter
 
def odd(n):
    return n & 1
 
def color(a):
    return 'green' if odd(a) else 'blue'
 
class Map:
 
    def __init__(self, master, rows = 30, columns = 50):
        self.master = master
        self.row = random.randrange(rows)
        self.col = random.randrange(columns)
        self.cost = 0
        self.found = False
        Button = tkinter.Button
        self.buttons = []
        options = dict(text = '**', font = 'Courier 14')
        for r in range(rows):
            br = []                 # row of buttons
            self.buttons.append(br)
            for c in range(columns):
                b = Button(
                    master,
                    command = lambda r=r, c=c: self(r, c),
                    fg = color(r+c),
                    height = 1, width = 2,
                    **options
                    )
                b.grid(row = r, column = c)
                br.append(b)
        master.mainloop()
 
    def __bool__(self):
        return self.found
 
    def __call__(self, row, col):
        if self:
            self.master.quit()
        distance = int(round(math.hypot(row-self.row, col-self.col)))
        self.buttons[row][col].configure(text = '{}'.format(distance), bg = 'yellow', fg = 'red')
        self.cost += 1
        if not distance:
            print('You win!  At the cost of {} radar devices.'.format(self.cost))
            self.found = True
 
def main():
    root = tkinter.Tk()
    map = Map(root)
    root.destroy()
 
if __name__ == '__main__':
    main()
