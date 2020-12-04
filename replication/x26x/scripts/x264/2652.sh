#!/bin/sh

numb='2653'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 15 --keyint 200 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.3,4.2,0.2,0.8,0.9,2,0,2,15,200,2,30,40,5,2,67,18,6,1000,-2:-2,hex,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"