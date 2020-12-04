#!/bin/sh

numb='1092'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 10 --keyint 230 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.6,1.2,2.6,0.2,0.6,0.0,3,2,14,10,230,3,25,50,4,3,65,18,6,2000,-2:-2,hex,crop,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"