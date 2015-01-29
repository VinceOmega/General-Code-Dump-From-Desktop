

<div id="select_form">
					<div class="select_body">
			<h3>Select an attorney</h3>
					
 				<form method="post" name="contact_form"
						action="">

							<select name="PraticeArea" id="PADropdown">
								<option value="">Select a Practice Area</option>
								<option value="partner">Partner</option>
								<option value="workers">PA Workers' Compenstation</option>
								<option value="social">Social Security Disability</option>
								<!-- <option value="general">General Law</option> -->
							</select>
							<br>
			
							<select name="LawyerNamePartner" class="dropdown" id="LawyerNamePartner">
							<% loop $getChildren(1) %>
								<option class="$LinkingMode" value="$Link">$Title</option>

						
							<% end_loop %>
								</select>
							
							<select name="LawyerNameWorkers" class="dropdown" id="LawyerNameWorkers">
							<% loop $getChildren(2) %>
									<option class="$LinkingMode" value="$Link">$Title</option>

						
							<% end_loop %>
								</select>						
						
							<select name="LawyerNameSocial" class="dropdown" id="LawyerNameSocial">
							<% loop $getChildren(3) %>
									<option class="$LinkingMode" value="$Link">$Title</option>

						
							<% end_loop %>
								</select>
					
							<select name="LawyerNameGeneral" class="dropdown" id="LawyerNameGeneral">
							<% loop $getChildren(4) %>
									<option class="$LinkingMode" value="$Link">$Title</option>

						
							<% end_loop %>
								</select>						

		<!-- 
							 <select name="LawyerNamePartners" class="lawyer-name-partners">
						
								<option value="$LinkingMode"></option>
						
							 </select>
		 -->
		
							<!-- <select name="LawyerNameWorkers" class="lawyer-name-workers">
							
								<option value="$LinkingMode">$MenuTitle</option>
							
							</select>
	
		
							<select name="LawyerNameSocial" class="lawyer-name-social">
						
								<option value="$LinkingMode">$MenuTitle</option>
						
							</select>
	
	
							<select name="LawyerNameGeneral" class="lawyer-name-general">
							
								<option value="$LinkingMode">$MenuTitle</option>
							
							</select> -->

							<br>
			
						

							<input id="submit_case" type="submit" value="" name="submit_case">
						</form>

					</div>
				</div>