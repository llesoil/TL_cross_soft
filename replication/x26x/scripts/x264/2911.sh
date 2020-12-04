#!/bin/sh

numb='2912'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 40 --keyint 260 --lookahead-threads 4 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.3,1.1,4.8,0.4,0.6,0.1,0,0,10,40,260,4,23,0,3,2,67,18,6,2000,-1:-1,dia,crop,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"