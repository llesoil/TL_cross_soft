#!/bin/sh

numb='416'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 10 --keyint 230 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.1,1.2,0.6,0.4,0.7,0.2,2,0,12,10,230,2,24,50,3,4,69,38,4,1000,-1:-1,dia,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"