library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package my_package is
    
    subtype STD_LOGIC_VECTOR_32 is STD_LOGIC_VECTOR(31 DOWNTO 0);
    subtype STD_LOGIC_VECTOR_16 is STD_LOGIC_VECTOR(15 DOWNTO 0);
    subtype STD_LOGIC_VECTOR_9  is STD_LOGIC_VECTOR( 8 DOWNTO 0);
    subtype STD_LOGIC_VECTOR_8  is STD_LOGIC_VECTOR( 7 DOWNTO 0);
    subtype STD_LOGIC_VECTOR_7  is STD_LOGIC_VECTOR( 6 DOWNTO 0);

    function "rol"(
        SIGNAL input    : STD_LOGIC_VECTOR_16;
        SIGNAL shift    : INTEGER
    ) return STD_LOGIC_VECTOR;

    procedure TR(
        variable nine   :  in STD_LOGIC_VECTOR_9;
        variable seven  : out STD_LOGIC_VECTOR_7);

    procedure ZE(
        variable seven  :  in STD_LOGIC_VECTOR_7;
        variable nine   : out STD_LOGIC_VECTOR_9);

    function FL(
        SIGNAL p        : STD_LOGIC_VECTOR_32;
        SIGNAL kl1, kl2 : STD_LOGIC_VECTOR_16
    ) return STD_LOGIC_VECTOR;

    procedure FI(
        variable p        : in  STD_LOGIC_VECTOR_16;
        variable ki       : in  STD_LOGIC_VECTOR_16;
        variable c        : out STD_LOGIC_VECTOR_16);

    function FO(
        SIGNAL p            : STD_LOGIC_VECTOR_32;
        SIGNAL ko1, ko2, ko3: STD_LOGIC_VECTOR_16;
        SIGNAL ki1, ki2, ki3: STD_LOGIC_VECTOR_16
    ) return STD_LOGIC_VECTOR;

    procedure KEY(
        SIGNAL k1, k2, k3, k4, k5, k6, k7, k8           : in  STD_LOGIC_VECTOR_16;
        constant c2, c6, c7, c8                           : in  STD_LOGIC_VECTOR_16;
        SIGNAL kl1, kl2, ko1, ko2, ko3, ki1, ki2, ki3     : out STD_LOGIC_VECTOR);
    
end package my_package;

package body my_package is
    
    function "rol"(
        SIGNAL input    : STD_LOGIC_VECTOR_16;
        SIGNAL shift    : INTEGER
        ) return STD_LOGIC_VECTOR is

        variable output: STD_LOGIC_VECTOR_16;

    begin
        output := input(15-shift DOWNTO 0) & input(15 DOWNTO 16-shift);
        return output;
    end "rol";


    procedure TR(
        variable nine   :  in STD_LOGIC_VECTOR_9;
        variable seven  : out STD_LOGIC_VECTOR_7) is
    begin
        seven := nine(6 DOWNTO 0);
    end TR;


    procedure ZE(
        variable seven  :  in STD_LOGIC_VECTOR_7;
        variable nine   : out STD_LOGIC_VECTOR_9) is
    begin
        nine := "00" & seven;
    end ZE;


    function FL(
        SIGNAL p        : STD_LOGIC_VECTOR_32;
        SIGNAL kl1, kl2 : STD_LOGIC_VECTOR_16
        ) return STD_LOGIC_VECTOR is

        variable rout: STD_LOGIC_VECTOR(15 DOWNTO 0);
        variable lout: STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    begin

        rout := ((p(31 DOWNTO 16) AND kl1) rol 1) XOR p(15 DOWNTO 0);
        lout := ((rout OR kl2) rol 1) XOR p(31 DOWNTO 16);

        return lout & rout;       
    end FL;


    procedure FI(
        variable p        : in  STD_LOGIC_VECTOR_16;
        variable ki       : in  STD_LOGIC_VECTOR_16;
        variable c        : out STD_LOGIC_VECTOR_16) is

        TYPE Sbox7 IS ARRAY (0 TO 127) OF INTEGER;
        TYPE Sbox9 IS ARRAY (0 TO 511) OF INTEGER;

        variable S_boxes7 : Sbox7;
        variable S_boxes9 : Sbox9;
            
        variable lout1      : STD_LOGIC_VECTOR_9;
        variable lout2      : STD_LOGIC_VECTOR_7;
        variable lout3      : STD_LOGIC_VECTOR_9;
        variable lout4      : STD_LOGIC_VECTOR_7;
        variable zextend    : STD_LOGIC_VECTOR_9;
        variable truncate   : STD_LOGIC_VECTOR_7;

    begin

        S_boxes7 :=(
        --  0    1   2   3   4   5   6   7   8   9   10  11  12  13  14  15
            54 , 50, 62, 56, 22, 34, 94, 96, 38, 6 , 63, 93, 2 , 18,123, 33,
            55 ,113, 39,114, 21, 67, 65, 12, 47, 73, 46, 27, 25,111,124, 81,
            53 , 9 ,121, 79, 52, 60, 58, 48,101,127, 40,120,104, 70, 71, 43,
            20 ,122, 72, 61, 23,109, 13,100, 77, 1 , 16, 7 , 82, 10,105, 98,
            117,116, 76, 11, 89,106, 0 ,125,118, 99, 86, 69, 30, 57,126, 87,
            112, 51, 17, 5 , 95, 14, 90, 84, 91, 8 , 35,103, 32, 97, 28, 66,
            102, 31, 26, 45, 75, 4 , 85, 92, 37, 74, 80, 49, 68, 29,115, 44,
            64 ,107,108, 24,110, 83, 36, 78, 42, 19, 15, 41, 88,119, 59, 3);

        S_boxes9 :=(
        --   0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15	
            167,239,161,379,391,334, 9 ,338, 38,226, 48,358,452,385, 90,397,
            183,253,147,331,415,340, 51,362,306,500,262, 82,216,159,356,177,
            175,241,489, 37,206, 17, 0 ,333, 44,254,378, 58,143,220, 81,400,
            95 , 3 ,315,245, 54,235,218,405,472,264,172,494,371,290,399, 76,
            165,197,395,121,257,480,423,212,240, 28,462,176,406,507,288,223,
            501,407,249,265, 89,186,221,428,164, 74,440,196,458,421,350,163,
            232,158,134,354, 13,250,491,142,191, 69,193,425,152,227,366,135,
            344,300,276,242,437,320,113,278, 11,243, 87,317, 36, 93,496, 27,
            487,446,482, 41, 68,156,457,131,326,403,339, 20, 39,115,442,124,
            475,384,508, 53,112,170,479,151,126,169, 73,268,279,321,168,364,
            363,292, 46,499,393,327,324, 24,456,267,157,460,488,426,309,229,
            439,506,208,271,349,401,434,236, 16,209,359, 52, 56,120,199,277,
            465,416,252,287,246, 6 , 83,305,420,345,153,502, 65, 61,244,282,
            173,222,418, 67,386,368,261,101,476,291,195,430, 49, 79,166,330,
            280,383,373,128,382,408,155,495,367,388,274,107,459,417, 62,454,
            132,225,203,316,234, 14,301, 91,503,286,424,211,347,307,140,374,
            35 ,103,125,427, 19,214,453,146,498,314,444,230,256,329,198,285,
            50 ,116, 78,410, 10,205,510,171,231, 45,139,467, 29, 86,505, 32,
            72 , 26,342,150,313,490,431,238,411,325,149,473, 40,119,174,355,
            185,233,389, 71,448,273,372, 55,110,178,322, 12,469,392,369,190,
            1  ,109,375,137,181, 88, 75,308,260,484, 98,272,370,275,412,111,
            336,318, 4 ,504,492,259,304, 77,337,435, 21,357,303,332,483, 18,
            47 , 85, 25,497,474,289,100,269,296,478,270,106, 31,104,433, 84,
            414,486,394, 96, 99,154,511,148,413,361,409,255,162,215,302,201,
            266,351,343,144,441,365,108,298,251, 34,182,509,138,210,335,133,
            311,352,328,141,396,346,123,319,450,281,429,228,443,481, 92,404,
            485,422,248,297, 23,213,130,466, 22,217,283, 70,294,360,419,127,
            312,377, 7 ,468,194, 2 ,117,295,463,258,224,447,247,187, 80,398,
            284,353,105,390,299,471,470,184, 57,200,348, 63,204,188, 33,451,
            97 , 30,310,219, 94,160,129,493, 64,179,263,102,189,207,114,402,
            438,477,387,122,192, 42,381, 5 ,145,118,180,449,293,323,136,380,
            43 , 66, 60,455,341,445,202,432, 8,237, 15 ,376,436,464, 59,461);

        ZE(p(6 DOWNTO 0), zextend);
        lout1 := conv_std_logic_vector(S_boxes9(conv_integer(p(15 DOWNTO 7))), 9) XOR zextend;
        TR(lout1, truncate);
        lout2 := conv_std_logic_vector(S_boxes7(conv_integer(p( 6 DOWNTO 0))), 7) XOR truncate XOR ki(15 DOWNTO 9);
        ZE(lout2, zextend);
        lout3 := conv_std_logic_vector(S_boxes9(conv_integer(lout1 XOR ki(8 DOWNTO 0))), 9) XOR zextend;
        TR(lout3, truncate);
        lout4 := conv_std_logic_vector(S_boxes7(conv_integer(lout2)), 7) XOR truncate;
        c := lout4 & lout3;
        
    end FI;

    function FO(
        SIGNAL p            : STD_LOGIC_VECTOR_32;
        SIGNAL ko1, ko2, ko3: STD_LOGIC_VECTOR_16;
        SIGNAL ki1, ki2, ki3: STD_LOGIC_VECTOR_16
    ) return STD_LOGIC_VECTOR is

        variable p_v    : STD_LOGIC_VECTOR_32;
        variable ki1_v  : STD_LOGIC_VECTOR_16;
        variable ki2_v  : STD_LOGIC_VECTOR_16;
        variable ki3_v  : STD_LOGIC_VECTOR_16;
        variable lin1   : STD_LOGIC_VECTOR_16;
        variable lin2   : STD_LOGIC_VECTOR_16;
        variable lin3   : STD_LOGIC_VECTOR_16;
        variable lout1  : STD_LOGIC_VECTOR_16;
        variable lout2  : STD_LOGIC_VECTOR_16;
        variable lout3  : STD_LOGIC_VECTOR_16;

    begin
        p_v   := p;
        ki1_v := ki1;
        ki2_v := ki2;
        ki3_v := ki3;
        lin1 := p_v(31 DOWNTO 16) XOR ko1;
        FI(lin1, ki1_v, lout1);
        lin2 := p_v(15 DOWNTO 0) XOR ko2;
        FI(lin2, ki2_v, lout2);
        lin3 := lout1 XOR p_v(15 DOWNTO 0) XOR ko3;
        FI(lin3, ki3_v, lout3);
        return (lout2 XOR lout1 XOR p_v(15 DOWNTO 0)) & (lout3 XOR lout2 XOR lout1 XOR p_v(15 DOWNTO 0));
    end FO;
    

    procedure KEY(
        SIGNAL k1, k2, k3, k4, k5, k6, k7, k8:        in STD_LOGIC_VECTOR_16;
        constant c2, c6, c7, c8:                        in STD_LOGIC_VECTOR_16;
        SIGNAL kl1, kl2, ko1, ko2, ko3, ki1, ki2, ki3: out STD_LOGIC_VECTOR) is

    begin
        kl1 <= k1 rol 1;
        kl2 <= k2 XOR c2;
        ko1 <= k3 rol 5;
        ko2 <= k4 rol 8;
        ko3 <= k5 rol 13;
        ki1 <= k6 XOR c6;
        ki2 <= k7 XOR c7;
        ki3 <= k8 XOR c8;
    end procedure;
end package body my_package;