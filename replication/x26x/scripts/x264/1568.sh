#!/bin/sh

numb='1569'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 45 --keyint 250 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.1,1.4,4.4,0.2,0.9,0.3,2,2,0,45,250,1,28,10,5,4,60,38,3,2000,-1:-1,umh,show,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"