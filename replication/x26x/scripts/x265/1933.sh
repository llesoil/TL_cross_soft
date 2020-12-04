#!/bin/sh

numb='1934'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 25 --keyint 210 --lookahead-threads 3 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.6,1.1,3.6,0.2,0.7,0.6,0,0,16,25,210,3,26,30,4,2,61,38,4,2000,1:1,dia,crop,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"