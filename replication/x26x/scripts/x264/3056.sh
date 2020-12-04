#!/bin/sh

numb='3057'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 40 --keyint 240 --lookahead-threads 2 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.3,1.2,2.6,0.2,0.8,0.7,3,1,2,40,240,2,27,10,5,1,67,48,6,1000,-1:-1,dia,crop,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"