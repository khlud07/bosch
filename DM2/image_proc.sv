module image_proc #(
	parameter DATA_BW = 8
)( 
		input logic i_clk, i_rstn,
		input logic [1:0] i_config_select,
		input logic i_dxi_in_valid,
		input logic [DATA_BW*9-1:0] i_dxi_in_data,
		input logic i_dxi_out_ready,
		output logic o_dxi_in_ready,
		output logic o_dxi_out_valid,
		output logic [DATA_BW-1:0] o_dxi_out_data,	
		);
	typedef logic [DATA_BW-1:0] pix_arr [8:0] // 9 pixels, each 8-bit
	typedef integer mask_arr [8:0] // array for filter


	// mask, choosing by i_config_select

	mask_arr laplacian_1 '{0, -1, 0, -1, 4, -1, 0, -1, 0};     
	mask_arr laplacian_2 '{-1, -1, -1, -1, 8, -1, -1, -1, -1}; 
	mask_arr gauss '{1, 2, 1, 2, 4, 2, 1, 2, 1}';
	mask_arr avrg '{1 1 1 1 1 1 1 1 1}';


	//unpacking
	function pix_arr unpacking (input logic [DATA_BW*9-1:0] i_dxi_in_data);		
		pix_arr pixel;
	    for (int i = 0; i < 9; i++) begin																	// structuring input
	        pixel[i] = i_dxi_in_data[(DATA_BW*9-1 - i*DATA_BW) : ((DATA_BW*9-1 - i*DATA_BW) - i*DATA_BW)];  // pixel[i] is the i-st DATA_BW bits of input flow
	    end
	    return pixel;
	endfunction 


	// applying mask and normalise
	function logic [DATA_BW-1:0] apply_mask (input logic pix_arr pixel [DATA_BW-1:0], input [1:0] i_config_select);
		int [1:0] norm = 1;
		mask_arr mask;
		int result;

		case (i_config_select)
			2b'00: mask = laplacian_1; norm = 1;
			2b'01: mask = laplacian_2; norm = 1;
			2b'10: mask = gauss; norm = 16;
			2b'11: mask = avrg; norm = 9;
		endcase

		
