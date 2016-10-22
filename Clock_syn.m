%Let n be the number of nodes in the simuklation
n = 10;
%define a structure to hold the table of clock values
table = struct( 'id' , '1' , 'value' , '0' , 'lcontact' , '0'  , 'lambda' , '0' , 'weight' , '1' );
%define the node
node = struct( 'id','1' , 'clock' , '0' , 'table' , table ) ;

% Define global variables to hold the Clock Offset and Logical time
Clk_off = zeros(1,n);
% Initialise the clocks for all the processes

for i = 1 : n
    node(i).id = i;
    node(i).clock = 0;
    for j = 1: n
        node(i).table(j).id = j ;
        node(i).table(j).value = 0;
        node(i).table(j).lcontact = 0;
        node(i).table(j).lambda = 0.99;
        node(i).table(j).weight = 0;
    end
    node(i).table(i).weight = 1;
end
        

%Start simulation for the duration of simulation
duration = 5000;
fq=0;

for i = 1: duration
    %Increments the clocks of some random processes. Asumme atmost 3
    %processes increment clock at any time
    num = randi(n , 1);
    for j = 1: num
        %Increment local clock of procees j
        k = randi(10,1);
        node(k).clock = node(k).clock + 1;
        %Update the clock in vector table also
        node(k).table(k).value = node(k).clock;
    end
    
    %Now randomly pick any two nodes to indicate that they are able to
    %communicate noe
    n1=0;
    n2=0;
    while(n1 == n2)
        n1 = randi(10,1);
        n2 = randi(10,1);
    end
    %Exchange and update the table between these two nodes after comparing
    %them
    
    
    
    %For the first node
    for entry = 1 : n
        if(node(n1).table(entry).value<node(n2).table(entry).value)
            %node n2 has more recent information about clock
            if(fq==1)
                w = node(n1).table(entry).weight;
            else
                w = 1;
            end
            node(n1).table(entry).value =w * node(n2).table(entry).value ;
        end
    end
    %For the second node
    for entry = 1 : n
        if(node(n2).table(entry).value<node(n1).table(entry).value)
            %node n2 has more recent information about clock
            if(fq==1)
                w = node(n1).table(entry).weight;
            else
                w = 1;
            end
            node(n2).table(entry).value = w * node(n1).table(entry).value ;
        end
    end
    %Exchange of data is done now update the lcontact value
    node(n1).table(n2).lcontact = i;
    node(n2).table(n1).lcontact = i;
    
    %Update the new weights 
    node(n1).table(n2).weight = 1;
    node(n2).table(n1).weight = 1;
    
    
    %Determine the clock offset at this instant
    sumd = 0;
    for li =1 : n
        %find the aggregate of clock values for a process in others
        clksum = 0;
        for ji = 1 : n
            clksum = clksum + node(ji).table(li).value ;
        end
            
        diff = n*node(li).clock - clksum ;
        sumd = sumd+diff;
        
    end
    Clk_off(i) = sumd/n;
    
    %decrement the the weights after the iteration according to the
    %assigned Aging parameter
    for nd = 1 : n
        for tb = 1: n
            node(nd).table(tb).weight = node(nd).table(tb).weight * node(nd).table(tb).lambda;
        end
    end
    
end
%plotting for values within interval 100
figure
plot(Clk_off(1:100))
title('Clock Offset variations in the interval 1 to 100')
xlabel('Logical time units')
ylabel('Global Relative Clock offset')
%plotting for values within interval 1000
figure
plot(Clk_off(1:1000))
title('Clock Offset variations in the interval 1 to 1000')
xlabel('Logical time units')
ylabel('Global Relative Clock offset')# DTN
