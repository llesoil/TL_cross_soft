#!/bin/sh

numb='2593'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 5 --keyint 230 --lookahead-threads 2 --min-keyint 24 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.6,1.1,2.4,0.5,0.7,0.5,0,0,0,5,230,2,24,30,5,2,68,18,6,2000,-1:-1,hex,crop,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"