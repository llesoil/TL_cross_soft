#!/bin/sh

numb='2003'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 0 --keyint 220 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.2,1.1,0.2,0.4,0.9,0.5,2,0,14,0,220,4,29,30,5,3,66,28,5,2000,1:1,dia,crop,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"