#!/bin/sh

numb='1580'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 10 --keyint 270 --lookahead-threads 1 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.5,1.3,3.8,0.6,0.7,0.4,0,0,4,10,270,1,22,30,3,0,65,18,4,2000,1:1,dia,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"