`timescale 1ns / 1ps

typedef enum logic [1:0] {
    GREEN,
    YELLOW,
    RED,
    LEFT
    } traffic_light;
    



module light_fsm(
    input clk, rst_n,
    output traffic_light north, south, east, west
    );
    
    localparam DURATION_GREEN=40;
    localparam DURATION_LEFT=20;
    localparam DURATION_YELLOW=5;
    
    enum logic [2:0] {
        NS_GREEN,
        NS_YELLOW,
        EW_LEFT,
        EW_YELLOW,
        EW_GREEN,
        EW_YELLOW2,
        NS_LEFT,
        NS_YELLOW2
        }state,next_state;
        
        int counter;
        
        always_ff @(posedge clk or negedge rst_n)begin
            if(~rst_n)  state <= NS_GREEN;
            else        state <= next_state;
         end
         
        always_comb begin
    next_state = state;  
    case (state)
            NS_GREEN: 
                if (counter ==  DURATION_GREEN) 
                    next_state = NS_YELLOW;
            NS_YELLOW: 
                if (counter ==  DURATION_YELLOW) 
                    next_state = EW_LEFT;
            EW_LEFT: 
                if (counter ==  DURATION_LEFT) 
                    next_state = EW_YELLOW;
            EW_YELLOW: 
                if (counter ==  DURATION_YELLOW) 
                    next_state = EW_GREEN;
            EW_GREEN: 
                if (counter ==  DURATION_GREEN) 
                    next_state = EW_YELLOW2;
            EW_YELLOW2: 
                if (counter ==  DURATION_YELLOW) 
                    next_state = NS_LEFT;
            NS_LEFT: 
                if (counter ==  DURATION_LEFT) 
                    next_state = NS_YELLOW2;
            NS_YELLOW2: 
                if (counter ==  DURATION_YELLOW) 
                    next_state = NS_GREEN;
            default: 
                next_state = NS_GREEN;            
    endcase
end
    always_ff @(posedge clk or negedge rst_n)
begin   
    north <= RED;
    south <= RED;
    east  <= RED;
    west  <= RED;
    
    if(state  != next_state) begin
        counter <= 0;
    end
    else begin    
        counter <= counter + 1;
    end
    
    case(next_state)
            NS_GREEN: 
                begin 
                north <= GREEN;
                south <= GREEN;
                end
            NS_YELLOW: 
                begin
                north <= YELLOW;
                south <= YELLOW;
                end
            EW_LEFT: 
                begin
                east <= LEFT;
                west <= LEFT;
                end
            EW_YELLOW: 
                begin
                east <= YELLOW;
                west <= YELLOW;
                end
            EW_GREEN: 
                begin
                east <= GREEN;
                west <= GREEN; 
                end
            EW_YELLOW2: 
                begin 
                east <= YELLOW;
                west <= YELLOW;
                end
            NS_LEFT: 
                begin
                north <= LEFT;
                south <= LEFT;
                end
            NS_YELLOW2: 
                begin
                north <= YELLOW;
                south <= YELLOW;
             end  
    endcase 
end    
     
endmodule
