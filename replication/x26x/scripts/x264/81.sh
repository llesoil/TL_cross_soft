#!/bin/sh

numb='82'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 45 --keyint 280 --lookahead-threads 2 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.4,1.1,2.4,0.2,0.7,0.9,3,1,14,45,280,2,22,50,3,4,65,28,1,1000,1:1,umh,crop,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"