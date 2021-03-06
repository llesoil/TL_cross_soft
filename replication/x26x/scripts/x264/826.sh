#!/bin/sh

numb='827'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 45 --keyint 270 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.6,1.4,0.2,0.3,0.9,0.1,3,2,14,45,270,4,27,20,5,0,66,18,5,1000,1:1,umh,crop,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"