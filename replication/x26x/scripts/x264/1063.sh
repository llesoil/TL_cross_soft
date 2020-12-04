#!/bin/sh

numb='1064'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 45 --keyint 270 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.0,1.1,0.8,0.4,0.9,0.6,1,2,12,45,270,1,29,10,3,1,61,38,1,1000,-2:-2,hex,show,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"