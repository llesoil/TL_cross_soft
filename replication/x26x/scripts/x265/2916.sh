#!/bin/sh

numb='2917'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 25 --keyint 220 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.1,1.3,3.2,0.6,0.9,0.7,2,2,12,25,220,4,25,10,4,0,62,38,5,1000,-1:-1,hex,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"