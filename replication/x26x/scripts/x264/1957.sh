#!/bin/sh

numb='1958'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 40 --keyint 250 --lookahead-threads 0 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.0,1.0,1.2,0.2,0.7,0.8,0,2,10,40,250,0,25,10,5,0,66,38,5,2000,-2:-2,dia,show,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"