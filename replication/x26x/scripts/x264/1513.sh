#!/bin/sh

numb='1514'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 10 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.0,2.0,0.5,0.8,0.0,0,1,8,10,200,0,30,40,5,2,61,48,6,1000,-2:-2,hex,show,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"