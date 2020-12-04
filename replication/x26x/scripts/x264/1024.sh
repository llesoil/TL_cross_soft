#!/bin/sh

numb='1025'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 45 --keyint 240 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.6,1.0,3.8,0.5,0.9,0.7,1,2,4,45,240,0,25,40,5,4,64,38,1,2000,1:1,dia,crop,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"