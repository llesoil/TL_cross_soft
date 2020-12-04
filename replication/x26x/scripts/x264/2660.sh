#!/bin/sh

numb='2661'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 15 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.6,1.4,4.4,0.2,0.9,0.3,2,1,10,15,230,2,30,50,5,0,63,38,2,1000,-2:-2,dia,crop,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"