#!/bin/sh

numb='2502'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 35 --keyint 240 --lookahead-threads 4 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.6,1.0,1.6,0.4,0.8,0.4,0,2,8,35,240,4,25,40,5,0,63,28,3,1000,-2:-2,dia,show,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"