#include <AT89C513xA.h>

void delay(void);

void main(void)
{
	while(1)
	{
		P1 = 0x80;
		delay();
		delay();
		delay();
		delay();
		P1 = 0x00;
		delay();
	}
}

void delay(void)
{
	int i,j;
	for(i=0; i<0xff;i++)
		for(j=0; j<0xff;j++);
}
