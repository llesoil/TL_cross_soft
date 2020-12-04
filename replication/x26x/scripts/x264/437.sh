#!/bin/sh

numb='438'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 45 --keyint 300 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 1 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.0,1.4,1.2,0.6,0.9,0.6,0,0,16,45,300,2,22,10,5,1,66,28,4,1000,-2:-2,hex,crop,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"