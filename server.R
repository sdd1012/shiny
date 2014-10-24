library(shiny)
library(ggplot2)
data(mtcars)
mtcars$cyl<- factor(mtcars$cyl)
levels(mtcars$cyl)<- c("4-Cyl","6-Cyl", "8-Cyl")
mtcars$wt<- mtcars$wt*1000
q<- qplot(wt,mpg,data=mtcars, color=cyl,geom=c("point","smooth"), method="lm" )
fit<- lm(mpg~wt+cyl, data=mtcars)
fitHp<- lm(mpg~wt+cyl+hp, data=mtcars)
coefs<- coefficients(fit)
coefsHp<- coefficients(fitHp)

shinyServer(
        function(input, output) {
                                
                output$text1 <- renderText({"The models here are prepared using R dataset 'mtcars'."})
                #output$text1 <- renderText({paste0("The cylinder type is ",input$inputCyl)})
                
                output$main_plot <- renderPlot({
                        weight<- input$inputWt
                        cyl_txt<- input$inputCyl
                        useHp<- input$inputUseHp
                        valueFor1n5<- coefs[1]
                        coef2<- coefs[2]
                        coef3<- coefs[3]
                        coef4<- coefs[4]
                        if(useHp){
                                hpValue<- input$inputHp 
                                valueFor1n5<- coefsHp[1]+coefsHp[5]*hpValue
                                coef2<- coefsHp[2]
                                coef3<- coefsHp[3]
                                coef4<- coefsHp[4]
                        }
                        mpg_fitted<- valueFor1n5 + coef2*weight + 
                                coef3*(cyl_txt=="six") +
                                coef4*(cyl_txt=="eight")
                        z<- round(mpg_fitted,2)
                        if(input$goButton==0)q
                        else if(input$goButton>0)
                        q + geom_point(x=weight,y=z, pch=13, cex=5,
                                       color="black") +
                                annotate("text", x = weight, y = z+1, 
                                         label = paste0("Estimated mpg =",z))
                        
                })
        }
)