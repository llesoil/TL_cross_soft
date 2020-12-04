#!/bin/sh

numb='429'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 50 --keyint 290 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.0,1.3,1.2,0.2,0.7,0.4,1,2,16,50,290,4,20,0,4,1,64,48,1,1000,-1:-1,hex,show,ultrafast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"