#!/bin/sh

numb='1607'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 10 --keyint 200 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.5,1.4,4.6,0.6,0.8,0.9,0,0,12,10,200,2,28,50,5,3,63,48,1,2000,-2:-2,umh,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"