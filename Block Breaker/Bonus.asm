;Azan Shehzad
;22i-2068
.model small
.stack 0100h

draw_dot macro p1, p2, c ; xaxis,yaxis,color

    Mov DX,0
    MOV CX, p1
    MOV DL, p2
    MOV AL, c
    MOV AH, 0CH
    int 10h

endm

draw_bricks macro life, x1, y1, x2, y2 ; Life/Status of the Brick, x1 y1 top left points, x2 y2 bottom right points

    push x1
    push y1
    push x2
    push y2

    mov bx,x2

.if(life>=0)

    .while(x1<bx)
        
        push bx
        mov bx,y2
        push y1
        .while(y1<bx)
        
            Mov CX,x1
            Mov DX,y1

            Mov Al,3
            Mov AH,0CH
            int 10H

            ADD y1,1

        .endw

        pop y1
        pop bx
        ADD x1,1

    .endw

.endif

        pop y2
        pop x2
        pop y1
        pop x1
            
        
endm

draw_ball macro x_point, y_point, ball_color ;(x,y) center point of Ball with color

    push x_point
    push y_point

    sub x_point,1
    sub y_point,1
    
    mov bl,3

    .while(bl>0)

        push y_point
        mov bh,3
        .while(bh>0)
            
            Mov CX,x_point
            Mov DX,y_point

            Mov AL,ball_color
            Mov AH,0CH

            INT 10H

            add y_point,1
            dec bh

        .endw

        pop y_point
        add x_point,1
        dec bl

    .endw

    pop y_point
    pop x_point

endm

draw_bar macro p1, p2, p3   ;150,190,200
    
    push p1
    mov bx,p3
    mov dx,0
    .while(p1 < bx) ;10
    
        MOV CX, p1 ; 160
        MOV DL, p2 ; 190
    
        MOV AL, 14 
        MOV AH, 0CH
        int 10h
    
        ADD p1,1

    .endw
        pop p1

endm

ball_movement macro x_point, y_point, ball_dir; (x,y) of Ball with directions

    .if(ball_dir==1)
        
        .if(x_point>=320)
        
        mov ball_dir,2
        
        .endif
        
        .if (y_point<=0)
        
        mov ball_dir,4
    
        .endif

    .elseif(ball_dir==2)
        
        .if(y_point<=0)
        
        mov ball_dir,3

        .endif

        .if(x_point<=0)

        mov ball_dir,1

        .endif

    .elseif(ball_dir==3)

        .if(x_point<=0)

        mov ball_dir,4

        .endif

        .if(y_point>=200)

        mov ball_dir,2

        .endif

    .elseif(ball_dir==4)

        .if(x_point>=320)
        
        mov ball_dir,3

        .endif

        .if(y_point>=200)

        mov ball_dir,1

        .endif

    .endif

    push ball_dir

endm

brick_movement macro x_point, y_point, life, x1, y1, x2, y2, ball_dir ;Position of ball and bricks with life and directions

push x_point
push y_point

mov ax,x1
mov bx,x2
mov cx,y1
mov dx,y2

.if(ball_dir==1)
        
    .if(x_point>=ax)

        .if(x_point<=bx)

            .if(y_point==dx)

                mov ball_dir,4
                mov life,0
                
            .endif
        
        .endif
    
    .endif

    .if(y_point>=cx)

        .if(y_point<=dx)

            .if(x_point==ax)

                mov ball_dir,2
                mov life,0

            .endif
        
        .endif
    
    .endif

.elseif(ball_dir==2)
                
    .if(x_point>=ax)

        .if(x_point<=bx)

            .if(y_point==dx)

                mov ball_dir,3
                mov life,0

            .endif
        
        .endif
    
    .endif

    .if(y_point>=cx)

        .if(y_point<=dx)

            .if(x_point==bx)

                mov ball_dir,1
                mov life,0

            .endif
        
        .endif
    
    .endif


.elseif(ball_dir==3)

    .if(x_point>=ax)

        .if(x_point<=bx)

            .if(y_point==cx)

                mov ball_dir,2
                mov life,0

            .endif
        
        .endif
    
    .endif

    .if(y_point>=cx)

        .if(y_point<=dx)

            .if(x_point==bx)

                mov ball_dir,4
                mov life,0

            .endif
        
        .endif
    
    .endif

.elseif(ball_dir==4)

    .if(x_point>=ax)

        .if(x_point<=bx)

            .if(y_point==cx)

                mov ball_dir,1
                mov life,0

            .endif
        
        .endif
    
    .endif

    .if(y_point>=cx)

        .if(y_point<=dx)

            .if(x_point==ax)

                mov ball_dir,3
                mov life,0

            .endif
        
        .endif
    
    .endif

.endif

    pop y_point
    pop x_point
    push life
    push ball_dir

endm

bar_movement macro x_point, y_point, BarLeftX, BarRightX, BarY, ball_dir ;(x,y) of ball with directions

push x_point
push y_point
push BarLeftX
push BarRightX

mov ax,BarLeftX
add ax,50
mov bx,BarLeftX
mov cx,0
mov cl,BarY

.if(ball_dir==3)
    
    .if(x_point>=bx)

        .if(x_point<=ax)

            .if(y_point==cx)

                mov ball_dir,2

            .endif
        
        .endif
    
    .endif

.elseif(ball_dir==4)
    
    .if(x_point>=bX)

        .if(x_point<=ax)

            .if(y_point==cx)

                mov ball_dir,1

            .endif
        
        .endif
    
    .endif
    
.endif

pop BarRightX
pop BarLeftX
pop y_point
pop x_point

push ball_dir

endm

.data 

    BarLeftX dw 150
    BarRightX dw 200
    BarY db 190 ;187
    black_dot db 0
    blue_dot db 1
    white_dot db 15
    ball_x dw 175
    ball_y dw 187
    ball_direction dw 1

BrickS STRUCT

    life dw 0
    x1 dw 0
    y1 dw 0
    x2 dw 0
    y2 dw 0

Bricks ends

;Blocks First Line

    b1 Bricks<1,30,10,80,20>
    b2 Bricks<1,95,10,145,20>   
    b3 Bricks<1,160,10,210,20>
    b4 Bricks<1,225,10,275,20>

;Blocks Second Line

    b5 Bricks<1,65,30,115,40>
    b6 Bricks<1,130,30,180,40>   
    b7 Bricks<1,195,30,245,40>

;Blocks Third Line

    b8 Bricks<1,95,50,145,60>   
    b9 Bricks<1,160,50,210,60>

;Blocks Fourth Line

    b10 Bricks<1,130,70,180,80> 
    
  
.code 
    mov ax,@data
    mov ds,ax
    Mov ah,00h
    Mov al,13h
    Int 10h

UpdateData:

;First Line
    draw_bricks b1.life,b1.x1,b1.y1,b1.x2,b1.y2 ;life,x1,y1,x2,y2
    draw_bricks b2.life,b2.x1,b2.y1,b2.x2,b2.y2
    draw_bricks b3.life,b3.x1,b3.y1,b3.x2,b3.y2
    draw_bricks b4.life,b4.x1,b4.y1,b4.x2,b4.y2
;Second Line
    draw_bricks b5.life,b5.x1,b5.y1,b5.x2,b5.y2
    draw_bricks b6.life,b6.x1,b6.y1,b6.x2,b6.y2
    draw_bricks b7.life,b7.x1,b7.y1,b7.x2,b7.y2
;Third Line
    draw_bricks b8.life,b8.x1,b8.y1,b8.x2,b8.y2
    draw_bricks b9.life,b9.x1,b9.y1,b9.x2,b9.y2
;Fourth Line
    draw_bricks b10.life,b10.x1,b10.y1,b10.x2,b10.y2
l1:
        
        draw_bar BarLeftX,BarY,BarRightX ; p1,p2,p3
        draw_ball ball_x,ball_y,white_dot ; (x,y) axis of ball with white color code
        mov ax,10000
        
        .while(ax>0)
        
            nop                 ;For Delay in movement of ball
            dec ax
        
        .endw

        ball_movement ball_x,ball_y,ball_direction

        pop ball_direction

        bar_movement ball_x, ball_y, BarLeftX, BarRightX, BarY, ball_direction

        pop ball_direction

;Bricks Mechanics

;First Line
    brick_movement ball_x,ball_y,b1.life,b1.x1,b1.y1,b1.x2,b1.y2,ball_direction ;life,x1,y1,x2,y2
    pop ball_direction
    
    brick_movement ball_x,ball_y,b2.life,b2.x1,b2.y1,b2.x2,b2.y2,ball_direction
    pop ball_direction
    
    brick_movement ball_x,ball_y,b3.life,b3.x1,b3.y1,b3.x2,b3.y2,ball_direction
    pop ball_direction
    
    brick_movement ball_x,ball_y,b4.life,b4.x1,b4.y1,b4.x2,b4.y2,ball_direction
    pop ball_direction

;Second Line
    brick_movement ball_x,ball_y,b5.life,b5.x1,b5.y1,b5.x2,b5.y2,ball_direction
    pop ball_direction
    
    brick_movement ball_x,ball_y,b6.life,b6.x1,b6.y1,b6.x2,b6.y2,ball_direction
    pop ball_direction

    brick_movement ball_x,ball_y,b7.life,b7.x1,b7.y1,b7.x2,b7.y2,ball_direction
    pop ball_direction

;Third Line
    brick_movement ball_x,ball_y,b8.life,b8.x1,b8.y1,b8.x2,b8.y2,ball_direction
    pop ball_direction

    brick_movement ball_x,ball_y,b9.life,b9.x1,b9.y1,b9.x2,b9.y2,ball_direction
    pop ball_direction
    
;Fourth Line
    brick_movement ball_x,ball_y,b10.life,b10.x1,b10.y1,b10.x2,b10.y2,ball_direction
    pop ball_direction

        mov bx,ball_direction

        cmp bx,1
        je dir1

        cmp bx,2
        je dir2

        cmp bx,3
        je dir3

        cmp bx,4
        je dir4


    dir1:

        draw_ball ball_x,ball_y,black_dot
        add ball_x,1
        sub ball_y,1
        draw_ball ball_x,ball_y,white_dot
        jmp keychecks
    
    dir2:

        draw_ball ball_x,ball_y,black_dot
        sub ball_x,1
        sub ball_y,1
        draw_ball ball_x,ball_y,white_dot
        jmp keychecks

    dir3:
            
        draw_ball ball_x,ball_y,black_dot
        sub ball_x,1
        add ball_y,1
        draw_ball ball_x,ball_y,white_dot
        jmp keychecks

    dir4:

        draw_ball ball_x,ball_y,black_dot
        add ball_x,1
        add ball_y,1
        draw_ball ball_x,ball_y,white_dot
        jmp keychecks

    keychecks:

        mov ah,1
        int 16h

        jz l1

        mov ah,0
        int 16h

        cmp al,13

        je exit

        mov al,ah

        cmp al,4bh
        je left

        cmp al,4dh
        je right

        jmp l1

right:

        cmp BarRightX,320
        je l1
        draw_dot BarLeftX,BarY,black_dot
        inc BarLeftX
        inc BarRightX

        jmp l1

left:

        cmp BarLeftX,0
        je l1
        draw_dot BarRightX,BarY,black_dot
        dec BarLeftX
        dec BarRightX
    
        jmp l1
        

exit:

mov ah,4ch
int 21h
end