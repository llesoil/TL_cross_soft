#!/bin/sh

numb='443'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 45 --keyint 260 --lookahead-threads 2 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.2,1.3,3.4,0.6,0.8,0.1,0,0,4,45,260,2,25,10,4,2,61,38,3,1000,-1:-1,hex,crop,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"