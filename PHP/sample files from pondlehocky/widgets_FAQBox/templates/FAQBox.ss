<div class="blog_rail">
					<h3>F.A.Q.s</h3>
					<ul>
			
						<% if $ParentID == 4 %>
							<% loop $getQuestionsType(1).limit(3) %>
					<li>
					<a class="$LinkingMode" href="$Link">$Title</a>
					</li>
							<% end_loop %>
			

						<% else_if $ParentID == 50 %>
						<% loop $getQuestionsType(2).limit(3) %>
					<li>
					<a class="$LinkingMode" href="$Link">$Title</a>
					</li>
							<% end_loop %>
				

					<% else %>

						<% loop $getQuestions.limit(3) %>
					
					<li>
					<a class="$LinkingMode" href="$Link">$Title</a>
					</li>

						<% end_loop %>
					<% end_if %>
					</ul>

					<a href="news-resources/faqs"><img class="learn_rail" src="themes/pondlehocky/gfx/learn_more_rail.png"></a>
				</div>