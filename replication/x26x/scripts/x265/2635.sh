#!/bin/sh

numb='2636'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 50 --keyint 260 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.3,1.4,1.0,0.2,0.6,0.5,2,2,14,50,260,0,26,20,5,4,67,28,2,1000,-1:-1,hex,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"