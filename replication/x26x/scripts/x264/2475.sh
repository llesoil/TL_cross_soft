#!/bin/sh

numb='2476'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 50 --keyint 280 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.6,1.0,4.6,0.2,0.6,0.7,3,1,8,50,280,0,26,20,4,1,67,38,4,2000,-1:-1,dia,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"