#!/bin/sh

numb='2354'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 40 --keyint 290 --lookahead-threads 3 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.0,1.3,2.4,0.3,0.8,0.6,2,0,16,40,290,3,29,30,4,0,62,38,5,2000,-1:-1,hex,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"